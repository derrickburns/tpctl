#!/bin/bash -i
#
# Configure EKS cluster to run Tidepool services
#

set -o pipefail
export FLUX_FORWARD_NAMESPACE=flux
export REVIEWERS="derrickburns pazaan jamesraby"
export SKIP_REVIEW=true  # FIXME should be passed and not hardcoded

function envoy {
  glooctl proxy served-config
}

function get_vpc {
  local cluster=$(get_cluster)
  aws cloudformation describe-stacks --stack-name eksctl-${cluster}-cluster | jq '.Stacks[0].Outputs| .[] | select(.OutputKey | contains("VPC")) | .OutputValue' | sed -e 's/"//g'
}

function find_peering_connections() {
  local vpc=$(get_vpc)
  aws ec2 describe-vpc-peering-connections --filters Name=accepter-vpc-info.vpc-id,Values=$vpc
  aws ec2 describe-vpc-peering-connections --filters Name=requester-vpc-info.vpc-id,Values=$vpc
}

function delete_peering_connections() {
  start "deleting peering connections"
  local ids=$(find_peering_connections | jq '.VpcPeeringConnections | .[].VpcPeeringConnectionId' | sed -e 's/"//g')
  confirm "Delete peering connections: $ids?"
  for id in ids
  do
    info "deleting peering connection $id"
    aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id  $id
  done
  complete "deleted peering connections"
}

function cluster_in_context() {
  context=$(KUBECONFIG=$(get_kubeconfig) kubectl config current-context 2>/dev/null)
  if [ $? -eq 0 ]; then
    echo $context
  else
    echo "none"
  fi
}

function install_certmanager {
  start "installing cert-manager"
  kubectl create namespace cert-manager
  kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml
  complete "installed cert-manager"
}

function mongo_template {
  cat <<! 
apiVersion: v1
data:
  Addresses:
  Database: tidepool
  OptParams:
  Password:
  Scheme: mongodb
  Tls: "true"
  Username:
kind: Secret
metadata:
  name: mongo
  namespace: qa1
type: Opaque
!
}

function uninstall_certmanager {
  start "uninstalling cert-manager"
  kubectl get Issuers,ClusterIssuers,Certificates,CertificateRequests,Orders,Challenges --all-namespaces -o yaml| kubectl delete -f -
  curl -sL https://github.com/jetstack/cert-manager/releases/download/v0.11.0/cert-manager.yaml | kubectl delete -f -
  kubectl delete namespace cert-manager
  complete "uninstalled cert-manager"
}


function make_envrc() {
  start "creating .envrc"
  local cluster=$(get_cluster)
  if [ -f kubeconfig.yaml ]
  then
    local context=$(yq r kubeconfig.yaml current-context)
    echo "kubectx $context" >.envrc
  fi
  echo "export REMOTE_REPO=cluster-$cluster" >>.envrc
  if [ -d ~/.helm/clusters/$cluster ]
  then
    echo "cp ~/.helm/clusters/$cluster/* ~/.helm/" >>.envrc
  fi
  add_file ".envrc"
  complete "created .envrc"
}

function cluster_in_repo() {
  yq r kubeconfig.yaml -j current-context | sed -e 's/"//g' -e "s/'//g"
}

function get_sumo_accessID() {
  echo $1 | jq '.accessID' | sed -e 's/"//g'
}

function get_sumo_accessKey() {
  echo $1 | jq '.accessKey' | sed -e 's/"//g'
}

function install_sumo() {
  start "installing sumo"
  local config=$(get_config)
  local cluster=$(get_cluster)
  local namespace=$(require_value "pkgs.sumologic.namespace")
  local apiEndpoint=$(require_value "pkgs.sumologic.apiEndpoint")
  local sumoSecret=$(aws secretsmanager get-secret-value --secret-id $cluster/$namespace/sumologic | jq '.SecretString | fromjson')
  local accessID=$(get_sumo_accessID $sumoSecret)
  local accessKey=$(get_sumo_accessKey $sumoSecret)
  curl -s https://raw.githubusercontent.com/SumoLogic/sumologic-kubernetes-collection/master/deploy/docker/setup/setup.sh |
    bash -s - -k $cluster -n $namespace -d false $apiEndpoint $accessID $accessKey >pkgs/sumologic/sumologic.yaml
  complete "installed sumo"
}

function install_glooctl {
  start "checking glooctl"
  local glooctl_version=$(require_value "pkgs.gloo.version")
  if ! command -v glooctl >/dev/null 2>&1 || [ $(glooctl version -o json | grep Client | yq r - 'Client.version') != ${glooctl_version} ]
  then
    start "installing glooctl"
    OS=$(ostype)
    local name="https://github.com/solo-io/gloo/releases/download/v${glooctl_version}/glooctl-${OS}-amd64"
    curl -sL -o /usr/local/bin/glooctl $name
    expect_success "Failed to download $name"
    chmod 755 /usr/local/bin/glooctl 
    complete "installed glooctl ${glooctl_version} for ${OS}"
  else
    complete "glooctl up-to-date"
  fi
}

# install gloo
function install_gloo() {
  install_glooctl
  start "installing gloo"
  local config=$(get_config)
  jsonnet --tla-code config="$config" $TEMPLATE_DIR/gloo/gloo-values.yaml.jsonnet | yq r - >$TMP_DIR/gloo-values.yaml
  expect_success "Templating failure gloo/gloo-values.yaml.jsonnet"

  kubectl delete jobs -n gloo-system gateway-certgen

  rm -rf gloo
  mkdir -p gloo
  (
    cd gloo
    glooctl install gateway -n gloo-system --values $TMP_DIR/gloo-values.yaml --dry-run | separate_files | add_names
    expect_success "Templating failure gloo/gloo-values.yaml.jsonnet"
  )

  if [ "$APPROVE" != "true" ]
  then
    confirm "Do you want to update API gateway directly now? "
  fi
  glooctl install gateway -n gloo-system --values $TMP_DIR/gloo-values.yaml
  expect_success "Gloo installation failure"
  complete "installed gloo"
}

function confirm_matching_cluster() {
  local in_context=$(cluster_in_context)
  local in_repo=$(cluster_in_repo)
  if [ "${in_repo}" != "${in_context}" ]; then
    echo "${in_context} is cluster selected in KUBECONFIG config file"
    echo "${in_repo} is cluster named in $REMOTE_REPO repo"
    confirm "Is $REMOTE_REPO the repo you want to use? "
  fi
}

function establish_ssh() {
  ssh-add -l &>/dev/null
  if [ "$?" == 2 ]; then
    # Could not open a connection to your authentication agent.

    # Load stored agent connection info.
    test -r ~/.ssh-agent &&
      eval "$(<~/.ssh-agent)" >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" == 2 ]; then
      # Start agent and store agent connection info.
      (
        umask 066
        ssh-agent >~/.ssh-agent
      )
      eval "$(<~/.ssh-agent)" >/dev/null
    fi
  fi

  # Load identities
  ssh-add -l &>/dev/null
  if [ "$?" == 1 ]; then
    # The agent has no identities.
    # Time to add one.
    ssh-add -t 4h
  fi
}

# set up colors to use for output
function define_colors() {
  RED=$(tput setaf 1)
  GREEN=$(tput setaf 2)
  MAGENTA=$(tput setaf 5)
  RESET=$(tput sgr0)
}

# irrecoverable error. Show message and exit.
function panic() {
  >&2 echo "${RED}[✖] ${1}${RESET}"
  exit 1
}

# confirm that previous command succeeded, otherwise panic with message
function expect_success() {
  if [ $? -ne 0 ]; then
    panic "$1"
  fi
}

# show info message
function start() {
 >&2 echo "${GREEN}[i] ${1}${RESET}"
}

# show info message
function complete() {
  >&2 echo "${MAGENTA}[√] ${1}${RESET}"
}

# show info message
function info() {
  >&2 echo "${MAGENTA}[√] ${1}${RESET}"
}

# report that file is being added to config repo
function add_file() {
  >&2 echo "${GREEN}[ℹ] adding ${1}${RESET}"
}

# report all files added to config repo from list given in stdin
function add_names() {
  while read -r line; do
    add_file $line
  done
}

# report renaming of file in config repo
function rename_file() {
  echo "${GREEN}[√] renaming ${1} ${2}${RESET}"
}

# conform action, else exit
function confirm() {
  if [ "$APPROVE" != "true" ]; then
    local msg=$1
    read -p "${RED}$msg${RESET} " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    else
      >&2 echo
    fi
  fi
}

# require that REMOTE_REPO env variable exists, expand REMOTE_REPO into full name
function check_remote_repo() {

  if [ -z "$REMOTE_REPO" ]; then
    panic "must provide REMOTE_REPO"
  fi

  if [[ $REMOTE_REPO != */* ]]; then
    GIT_REMOTE_REPO="git@github.com:tidepool-org/$REMOTE_REPO"
  else
    GIT_REMOTE_REPO=$REMOTE_REPO
  fi
  HTTPS_REMOTE_REPO=$(echo $GIT_REMOTE_REPO | sed -e "s#git@github.com:#https://github.com/#")

}

# clean up all temporary files
function cleanup() {
  if [ -d .git ]; then
      git reset
  fi
  if [ -f "$TMP_DIR" ]; then
    cd /
    rm -rf $TMP_DIR
  fi
}

# create temporary workspace to clone Git repos into, change to that directory
function setup_tmpdir() {
  if [[ ! -d $TMP_DIR ]]; then
    start "creating temporary working directory"
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'TMP_DIR')
    complete "created temporary working directory"
    trap cleanup EXIT
    #cd $TMP_DIR
  fi
}

function repo_with_token() {
  local repo=$1
  echo $repo | sed -e "s#https://#https://$GITHUB_TOKEN@#"
}

# clone remote 
function clone_remote() {
  if [ "$CLONE_REMOTE" == "true" ]; then
    cd $TMP_DIR
    if [[ ! -d $(basename $HTTPS_REMOTE_REPO) ]]; then
      start "cloning remote"
      git clone $(repo_with_token $HTTPS_REMOTE_REPO) >/dev/null
      expect_success "Cannot clone $HTTPS_REMOTE_REPO"
      complete "cloned remote"
    fi
    cd $(basename $HTTPS_REMOTE_REPO)
  fi
}

# clone quickstart repo, export TEMPLATE_DIR
function set_template_dir() {
  if [[ ! -d $TEMPLATE_DIR ]]; then
    start "cloning quickstart"
    pushd $TMP_DIR >/dev/null 2>&1
    git clone $(repo_with_token https://github.com/tidepool-org/tpctl)
    if [ -n "$TPCTL_BRANCH" ]; then
      (cd tpctl; git checkout $TPCTL_BRANCH)
    fi
    export TEMPLATE_DIR=$(pwd)/tpctl
    popd >/dev/null 2>&1
    complete "cloned quickstart"
  fi
}

# clone development repo, exports CHART_DIR
function set_chart_dir() {
  if [[ ! -d $CHART_DIR ]]; then
    start "cloning development tools"
    pushd $TMP_DIR >/dev/null 2>&1
    git clone $(repo_with_token https://github.com/tidepool-org/development)
    cd development
    git checkout develop
    CHART_DIR=$(pwd)/charts/tidepool/0.1.7
    popd >/dev/null 2>&1
    complete "cloned development tools"
  fi
}

# clone secret-map repo, export SM_DIR
function clone_secret_map() {
  if [[ ! -d $SM_DIR ]]; then
    start "cloning secret-map"
    pushd $TMP_DIR >/dev/null 2>&1
    git clone $(repo_with_token https://github.com/tidepool-org/secret-map)
    SM_DIR=$(pwd)/secret-map
    popd >/dev/null 2>&1
    complete "cloned secret-map"
  fi
}

# get values file
function get_config() {
  yq r values.yaml -j
}

# retrieve value from values file, or exit if it is not available
function require_value() {
  local val=$(yq r values.yaml -j $1 | sed -e 's/"//g' -e "s/'//g")
  if [ $? -ne 0 -o "$val" == "null" -o "$val" == "" ]; then
    panic "Missing $1 from values.yaml file."
  fi
  echo $val
}

# retrieve name of cluster
function get_cluster() {
  require_value "cluster.metadata.name"
}

# retrieve name of region
function get_region() {
  require_value "cluster.metadata.region"
}

# retrieve email address of cluster admin
function get_email() {
  require_value "email"
}

# retrieve AWS account number
function get_aws_account() {
  require_value "aws.accountNumber"
}

# retrieve list of AWS environments to create
function get_environments() {
  yq r values.yaml environments | sed -e "/^  .*/d" -e s/:.*//
}

# retrieve list of K8s system masters
function get_iam_users() {
  yq r values.yaml aws.iamUsers | sed -e "s/- //" -e 's/"//g'
}

# retrieve bucket name or create from convention
function get_bucket() {
  local env=$1
  local kind=$2
  local bucket=$(yq r values.yaml environments.${env}.tidepool.buckets.${kind} | sed -e "/^  .*/d" -e s/:.*//)
  if [ "$bucket" == "null" ]; then
    local cluster=$(get_cluster)
    echo "tidepool-${cluster}-${env}-${kind}"
  else
    echo $bucket
  fi
}

# create Tidepool assets bucket
function make_assets() {
  local env
  for env in $(get_environments); do
    local bucket=$(get_bucket $env asset)
    start "creating asset bucket $bucket"
    aws s3 mb s3://$bucket
    info "copying  dev assets into $bucket"
    aws s3 cp s3://tidepool-dev-asset s3://$bucket
    complete "created asset bucket $bucket"
  done
}

# retrieve helm home
function get_helm_home() {
  echo ${HELM_HOME:-~/.helm}
}

# make TLS certificate to allow local helm client to access tiller with TLS
function make_cert() {
  local cluster=$(get_cluster)
  local helm_home=$(get_helm_home)

  start "installing helm client cert for cluster $cluster"

  info "retrieving ca.pem from AWS secrets manager"
  aws secretsmanager get-secret-value --secret-id $cluster/flux/ca.pem | jq '.SecretString' | sed -e 's/"//g' \
    -e 's/\\n/\
/g' >$TMP_DIR/ca.pem

  expect_success "failed to retrieve ca.pem from AWS secrets manager"

  info "retrieving ca-key.pem from AWS secrets manager"
  aws secretsmanager get-secret-value --secret-id $cluster/flux/ca-key.pem | jq '.SecretString' | sed -e 's/"//g' \
    -e 's/\\n/\
/g' >$TMP_DIR/ca-key.pem

  expect_success "failed to retrieve ca-key.pem from AWS secrets manager"

  local helm_cluster_home=${helm_home}/clusters/$cluster

  info "creating cert in ${helm_cluster_home}"
  local tiller_hostname=tiller-deploy.flux
  local user_name=helm-client

  echo '{"signing":{"default":{"expiry":"43800h","usages":["signing","key encipherment","server auth","client auth"]}}}' >$TMP_DIR/ca-config.json
  echo '{"CN":"'$user_name'","hosts":[""],"key":{"algo":"rsa","size":4096}}' | cfssl gencert \
    -config=$TMP_DIR/ca-config.json -ca=$TMP_DIR/ca.pem -ca-key=$TMP_DIR/ca-key.pem \
    -hostname="$tiller_hostname" - | cfssljson -bare $user_name

  rm -rf $helm_cluster_home
  mkdir -p $helm_cluster_home
  mv helm-client.pem $helm_cluster_home/cert.pem
  add_file $helm_cluster_home/cert.pem
  mv helm-client-key.pem $helm_cluster_home/key.pem
  rm helm-client.csr
  add_file $helm_cluster_home/key.pem
  cp $TMP_DIR/ca.pem $helm_cluster_home/ca.pem
  add_file $helm_cluster_home/ca.pem
  rm -f $helm_home/{cert.pem,key.pem,ca.pem}
  cp $helm_cluster_home/{cert.pem,key.pem,ca.pem} $helm_home

  if [ "$TILLER_NAMESPACE" != "flux" -o "$HELM_TLS_ENABLE" != "true" ]; then
    info "you must do this to use helm:"
    info "export TILLER_NAMESPACE=flux"
    info "export HELM_TLS_ENABLE=true"
  fi
  complete "installed helm client cert for cluster $cluster"
}

# config availability of GITHUB TOKEN in environment
function expect_github_token() {
  if [ -z "$GITHUB_TOKEN" ]; then
    panic "\$GITHUB_TOKEN required. https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line"
  fi
}

# retrieve kubeconfig value
function get_kubeconfig() {
  local kc=$(require_value "kubeconfig")
  realpath $(eval "echo $kc")
}

function update_kubeconfig() {
  start "updating kubeconfig"
  local config=$(get_config)
  yq r ./kubeconfig.yaml -j >$TMP_DIR/kubeconfig.yaml
  jsonnet --tla-code-file prev=${TMP_DIR}/kubeconfig.yaml --tla-code config="$config" ${TEMPLATE_DIR}/eksctl/kubeconfig.jsonnet | yq r - >kubeconfig.yaml
  expect_success "updating kubeconfig failed"
  complete "updated kubeconfig"
}

# create EKS cluster using config.yaml file, add kubeconfig to config repo
function make_cluster() {
  local cluster=$(get_cluster)
  start "creating cluster $cluster"
  eksctl create cluster -f config.yaml --kubeconfig ./kubeconfig.yaml
  expect_success "eksctl create cluster failed."
  update_kubeconfig
  git pull
  add_file "./kubeconfig.yaml"
  make_envrc
  complete "created cluster $cluster"
}

function merge_kubeconfig() {
  local local_kube_config=$(realpath ./kubeconfig.yaml)
  local kubeconfig=$(get_kubeconfig)
  if [ "$kubeconfig" != "$local_kube_config" ]; then
    if [ -f "$kubeconfig" ]; then
      info "merging kubeconfig into $kubeconfig"
      KUBECONFIG=$kubeconfig:$local_kube_config kubectl config view --flatten >$TMP_DIR/updated.yaml
      cat $TMP_DIR/updated.yaml >$kubeconfig
    else
      mkdir -p $(dirname $kubeconfig)
      info "creating new $kubeconfig"
      cat $local_kube_config >$kubeconfig
    fi
  fi
}

# confirm that values file exists or panic
function expect_values_exists() {
  if [ ! -f values.yaml ]; then
    panic "No values.yaml file."
  fi
}

# remove computed pkgs
function reset_config_dir() {
  mv values.yaml $TMP_DIR/
  if [ $(ls | wc -l) -ne 0 ]; then
    confirm "Are you sure that you want to remove prior contents (except values.yaml)?"
    info "resetting config repo"
    rm -rf pkgs
  fi
  mv $TMP_DIR/values.yaml .
}

# return list of enabled packages
function enabled_pkgs() {
  local pkgs=""
  local directory=$1
  local key=$2
  for dir in $(ls $directory); do
    local pkg=$(basename $dir)
    local enabled=$(yq r values.yaml $key.${pkg}.enabled)
    if [ "$enabled" == "true" ]; then
      pkgs="${pkgs} $pkg"
    fi
  done
  echo $pkgs
}

# make K8s manifest file for shared services given config, path to directory, and prefix to strip
function template_files() {
  local config=$1
  local path=$2
  local prefix=$3
  local fullpath
  local cluster=$(get_cluster)
  local region=$(get_region)
  for fullpath in $(find $path -type f -print); do
    local filename=${fullpath#$prefix}
    mkdir -p $(dirname $filename)
    if [ "${filename: -5}" == ".yaml" ]; then
      add_file $filename
      cp $fullpath $filename
    elif [ "${filename: -13}" == ".yaml.jsonnet" ]; then
      add_file ${filename%.jsonnet}
      local prev=$TMP_DIR/${filename%.jsonnet}
      local out=$TMP_DIR/${filename%.jsonnet}.json
      if [ -f $prev ]; then
        yq r $prev -j >$out
	if [ $? -ne -0 ]
	then
          echo "{}" >$out
	fi
      else
        mkdir -p $(dirname $out)
        echo "{}" >$out
      fi
      jsonnet --tla-code-file prev=$out --tla-code config="$config" $fullpath | yq r - >${filename%.jsonnet}
      expect_success "Templating failure $filename"
    fi
  done
}

# make K8s manifest files for shared services
function make_shared_config() {
  start "creating package manifests"
  local config=$(get_config)
  cp -r pkgs $TMP_DIR 
  rm -rf pkgs
  local dir
  for dir in $(enabled_pkgs $TEMPLATE_DIR/pkgs pkgs); do
    template_files "$config" $TEMPLATE_DIR/pkgs/$dir $TEMPLATE_DIR/
  done
  complete "created package manifests"
}

# make EKSCTL manifest file
function make_cluster_config() {
  local config=$(get_config)
  start "creating eksctl manifest"
  add_file "config.yaml"
  jsonnet --tla-code config="$config" ${TEMPLATE_DIR}/eksctl/cluster_config.jsonnet | yq r - >config.yaml
  expect_success "Templating failure eksctl/cluster_config.jsonnet"
  complete "created eksctl manifest"
}

# make K8s manifests for enviroments given config, path, prefix, and environment name
function environment_template_files() {
  local config=$1
  local path=$2
  local prefix=$3
  local env=$4
  for fullpath in $(find $path -type f -print); do
    local filename=${fullpath#$prefix}
    local dir=environments/$env/$(dirname $filename)
    local file=$(basename $filename)
    mkdir -p $dir
    if [ "${file: -8}" == ".jsonnet" ]; then
      local out=$dir/${file%.jsonnet}
      local prev=$TMP_DIR/$dir/${file%.jsonnet}
      add_file $out
      if [ -f $prev ]; then
        yq r $prev -j >$TMP_DIR/${file%.jsonnet}
	if [ $? -ne -0 ]
	then
          echo "{}" >$TMP_DIR/${file%.jsonnet}
	fi
      else
        mkdir -p $(dirname  $TMP_DIR/${file%.jsonnet})
        echo "{}" >$TMP_DIR/${file%.jsonnet}
      fi
      jsonnet --tla-code-file prev=$TMP_DIR/${file%.jsonnet} --tla-code config="$config" --tla-str namespace=$env $fullpath | yq r - >$dir/${file%.jsonnet}
      expect_success "Templating failure $dir/$filename"
      rm $TMP_DIR/${file%.jsonnet}
    fi
  done
}

# make K8s manifests for environments
function make_environment_config() {
  local config=$(get_config)
  local env
  if [ -d environments ]
  then
    mv environments $TMP_DIR
  fi
  for env in $(get_environments); do
    start "creating $env environment manifests"
    for dir in $(enabled_pkgs $TEMPLATE_DIR/environments environments.$env); do
      environment_template_files "$config" $TEMPLATE_DIR/environments/$dir $TEMPLATE_DIR/environments/ $env
    done
    complete "created $env environment manifests"
  done
}

# create all K8s manifests and EKSCTL manifest
function make_config() {
  start "creating manifests"
  make_shared_config
  make_cluster_config
  make_environment_config
  complete "created manifests"
}

# persist changes to config repo in GitHub
function save_changes() {
  git add .
  expect_success "git add failed"
  export GIT_PAGER=/bin/cat
  DIFFS=$(git diff --cached HEAD)
  if [ -z "$DIFFS" ]
  then
    info "No changes made"
    return
  fi
  info "==== BEGIN Changes"
  git diff --cached HEAD
  info "==== END Changes"
  local branch
  if [ "$APPROVE" != "true" ]
  then
    confirm "Do you want to save these changes? "
    read -p "${GREEN}Branch name?${RESET} " -r
    branch=$REPLY
  else
    branch="tpctl-"+$(date "%Y%m%d%H%M%S")
  fi
  establish_ssh
  start "saving changes to config repo"
  git add .
  expect_success "git add failed"
  if [ "$branch" != "master" ]; then
    git checkout -b $branch
    expect_success "git checkout failed"
  fi
  expect_success "git checkout failed"
  git commit -m "$1"
  expect_success "git commit failed"
  complete "committed changes to config repo"
  git push origin $branch
  expect_success "git push failed"
  complete "pushed changes to config repo branch $branch"
  if [ "$SKIP_REVIEW" == true ]; then
   echo "Skipping review"
   return
  fi
  read -p "${GREEN}PR Message? ${RESET} " -r
  local message=$REPLY
  info "Please select PR reviewer: "
  select REVIEWER in none $REVIEWERS ;
  do
    if [ "$REVIEWER" == "none" ]
    then
      hub pull-request -m "$message" 
      expect_success "failed to create pull request, please create manually"
      complete "create pull request"
    else
      hub pull-request -m "$message" -r $REVIEWER
      expect_success "failed to create pull request, please create manually"
      complete "create pull request for review by $REVIEWER"
    fi
    return
  done
}

# confirm cluster exists or exist
function expect_cluster_exists() {
  local cluster=$(get_cluster)
  eksctl get cluster --name $cluster
  expect_success "cluster $cluster does not exist."
}

# install flux into cluster
function make_flux() {
  local cluster=$(get_cluster)
  local email=$(get_email)
  start "installing flux into cluster $cluster"
  establish_ssh
  EKSCTL_EXPERIMENTAL=true unbuffer eksctl enable repo \
    -f config.yaml --git-url=${GIT_REMOTE_REPO}.git --git-email=$email --git-label=$cluster | tee $TMP_DIR/eksctl.out
  expect_success "eksctl install flux failed."
  git pull
  complete "installed flux into cluster $cluster"
}

# save Certificate Authority key and pem into AWS secrets manager
function save_ca() {
  start "saving certificate authority TLS pem and key to AWS secrets manager"
  local cluster=$(get_cluster)
  local dir=$(cat $TMP_DIR/eksctl.out | grep "Public key infrastructure" | sed -e 's/^.*"\(.*\)".*$/\1/')

  aws secretsmanager describe-secret --secret-id $cluster/flux/ca.pem 2>/dev/null
  if [ $? -ne 0 ]; then
    aws secretsmanager create-secret --name $cluster/flux/ca.pem --secret-string "$(cat $dir/ca.pem)"
    expect_success "failed to create ca.pem to AWS"
    aws secretsmanager create-secret --name $cluster/flux/ca-key.pem --secret-string "$(cat $dir/ca-key.pem)"
    expect_success "failed to create ca-key.pem to AWS"
  else
    aws secretsmanager update-secret --secret-id $cluster/flux/ca.pem --secret-string "$(cat $dir/ca.pem)"
    expect_success "failed to update ca.pem to AWS"
    aws secretsmanager update-secret --secret-id $cluster/flux/ca-key.pem --secret-string "$(cat $dir/ca-key.pem)"
    expect_success "failed to update ca-key.pem to AWS"
  fi
  complete "saved certificate authority TLS pem and key to AWS secrets manager"
}

# save deploy key to config repo
function make_key() {
  start "authorizing access to ${GIT_REMOTE_REPO}"

  local key=$(fluxctl --k8s-fwd-ns=flux identity)
  local reponame="$(echo $GIT_REMOTE_REPO | cut -d: -f2 | sed -e 's/\.git//')"
  local cluster=$(get_cluster)

  curl -X POST -i \
    -H"Authorization: token $GITHUB_TOKEN" \
    --data @- https://api.github.com/repos/$reponame/keys <<EOF
        {

                "title" : "flux key for $cluster created by make_flux",
                "key" : "$key",
                "read_only" : false
        }
EOF
  complete "authorized access to ${GIT_REMOTE_REPO}"
}

function update_gloo_service() {
  local glooServiceFile=gloo/gloo-system/Service/gateway-proxy.yaml
  if [ -f $glooServiceFile ]; then
    start "updating gloo service"
    local config=$(get_config)
    local prev=$TMP_DIR/svc.json
    yq r $glooServiceFile -j >$prev
    jsonnet --tla-code config="$config" --tla-code-file prev=$prev $TEMPLATE_DIR/gloo/svc.jsonnet | yq r -  >$glooServiceFile
    expect_success "Templating failure $TEMPLATE_DIR/gloo/svc.jsonnet"
    add_file $glooServiceFile
    complete "updated gloo service"
  else
    info "No gloo service to update"
  fi
}

# update flux and helm operator manifests
function update_flux() {
  start "updating flux and flux-helm-operator manifests"
  local config=$(get_config)

  if [ -f flux/flux-deployment.yaml ]; then
    yq r flux/flux-deployment.yaml -j >$TMP_DIR/flux.json
    yq r flux/helm-operator-deployment.yaml -j >$TMP_DIR/helm.json
    yq r flux/tiller-dep.yaml -j >$TMP_DIR/tiller.json

    jsonnet --tla-code config="$config" --tla-code-file flux="$TMP_DIR/flux.json" --tla-code-file helm="$TMP_DIR/helm.json" $TEMPLATE_DIR/flux/flux.jsonnet --tla-code-file tiller="$TMP_DIR/tiller.json" >$TMP_DIR/updated.json
    expect_success "Templating failure flux/flux.jsonnet"

    add_file flux/flux-deployment.yaml
    yq r $TMP_DIR/updated.json flux >flux/flux-deployment.yaml
    expect_success "Serialization flux/flux-deployment.yaml"

    add_file flux/helm-operator-deployment.yaml
    yq r $TMP_DIR/updated.json helm >flux/helm-operator-deployment.yaml
    expect_success "Serialization flux/helm-operator-deployment.yaml"

    add_file flux/tiller-dep.yaml
    yq r $TMP_DIR/updated.json tiller >flux/tiller-dep.yaml
    expect_success "Serialization flux/tiller-dep.yaml"
  fi
  complete "updated flux and flux-helm-operator manifests"
}

function mykubectl() {
  KUBECONFIG=~/.kube/config kubectl $@
}

function ostype {
  case "$OSTYPE" in
  darwin*)  echo "darwin" ;; 
  linux*)   echo "linux" ;;
  bsd*)     echo "bsd" ;;
  msys*)    echo "windows" ;;
  *)        echo "unknown: $OSTYPE" ;;
  esac
}

function install_mesh_client {
  start "checking linkerd client"
  local linkerd_version=$(require_value "pkgs.linkerd.version")
  if ! command -v linkerd >/dev/null 2>&1 || [ $(linkerd version --client --short) != ${linkerd_version} ]
  then
    start "installing linkerd client"
    OS=$(ostype)
    local name="https://github.com/linkerd/linkerd2/releases/download/${linkerd_version}/linkerd2-cli-${linkerd_version}-${OS}"
    curl -sL -o /usr/local/bin/linkerd $name
    expect_success "Failed to download $name"
    chmod 755 /usr/local/bin/linkerd 
    complete "installed linkerd ${linkerd_version} for ${OS}"
  else
    complete "linkerd client up to date"
  fi
}

# create service mesh
# do NOT add linkerd to GitOps because upgrade path is can be complex
function make_mesh() {
  install_mesh_client
  linkerd check --pre
  expect_success "Failed linkerd pre-check."
  start "installing mesh"
  linkerd version
  info "linkerd check --pre"

  if [ "$APPROVE" != "true" ]
  then
    confirm "Do you want to install the mesh directly? "
  fi

  linkerd install config | mykubectl apply -f -

  linkerd check config
  while [ $? -ne 0 ]; do
    sleep 3
    info "retrying linkerd check config"
    linkerd check config
  done
  info "linkerd check config"

  linkerd install control-plane | mykubectl apply -f -

  linkerd check
  while [ $? -ne 0 ]; do
    sleep 3
    info "retrying linkerd check"
    linkerd check
  done

  kubectl annotate deployments -n linkerd -l linkerd.io/control-plane-component=proxy-injector "cluster-autoscaler.kubernetes.io/safe-to-evict=false"
  kubectl annotate pods -n linkerd -l linkerd.io/control-plane-component=proxy-injector "cluster-autoscaler.kubernetes.io/safe-to-evict=false"
  complete "installed mesh"
}

# get values from legacy environments
function get_legacy_values() {
  local kind=$1
  local cluster=$(get_cluster)
  local env
  for env in $(get_environments); do
    local source=$(yq r values.yaml environments.${env}.tidepool.source)
    if [ "$source" == "null" -o "$source" == "" ]; then
      continue
    fi
    if [ "$source" == "dev" -o "$source" == "stg" -o "$source" == "int" -o "$source" == "prd" ]; then
      $SM_DIR/bin/git_to_map $source | $SM_DIR/bin/map_to_k8s $env $kind
    else
      panic "Unknown secret source $source"
    fi
  done
}

# create k8s system master users
function make_users() {
  local group=system:masters
  local cluster=$(get_cluster)
  local aws_region=$(get_region)
  local account=$(get_aws_account)

  start "adding system masters"
  local user
  for user in $(get_iam_users); do
    local arn=arn:aws:iam::${account}:user/${user}
    eksctl create iamidentitymapping --region=$aws_region --role=$arn --group=$group --name=$cluster --username=$user
    while [ $? -ne 0 ]; do
      sleep 3
      eksctl create iamidentitymapping --region=$aws_region --role=$arn --group=$group --name=$cluster --username=$user
      info "retrying eksctl create iamidentitymapping"
    done
    info "added $user to cluster $cluster"
  done
  complete "added system masters"
}

# confirm that values.yaml file exists
function expect_values_not_exist() {
  if [ -f values.yaml ]; then
    confirm "Are you sure that you want to overwrite prior contents of values.yaml?"
  fi
}

# create initial values file
function make_values() {
  start "creating values.yaml"
  add_file "values.yaml"
  cat $TMP_DIR/tpctl/values.yaml >values.yaml
  cat >>values.yaml <<!
github:
  git: $GIT_REMOTE_REPO
  https: $HTTPS_REMOTE_REPO

!

  yq r values.yaml -j | jq '.cluster.metadata.name = .github.git' |
    jq '.cluster.metadata.name |= gsub(".*\/"; "")' |
    jq '.cluster.metadata.name |= gsub("cluster-"; "")' | yq r - >xxx.yaml
  mv xxx.yaml values.yaml
  if [ "$APPROVE" != "true" ]; then
    ${EDITOR:-vi} values.yaml
  fi
  complete "created values.yaml"
}

# enter into bash to allow manual editing of config repo
function edit_config() {
  info "exit shell when done making changes."
  bash
  confirm "Are you sure you want to commit changes?"
}

# show recent diff
function diff_config() {
  git diff HEAD~1
}

# edit values file
function edit_values() {
  if [ -f values.yaml ]; then
    info "editing values file for repo $GIT_REMOTE_REPO"
    ${EDITOR:-vi} values.yaml
  else
    panic "values.yaml does not exist."
  fi
}

# generate random secrets
function randomize_secrets() {
  set_chart_dir
  local env
  for env in $(get_environments); do
    local file
    for file in $(find $CHART_DIR -name \*secret.yaml -print); do
      helm template --namespace $env --set global.secret.generated=true $CHART_DIR -f $CHART_DIR/values.yaml -x $file >$TMP_DIR/x
      grep "kind" $TMP_DIR/x >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        cat $TMP_DIR/x
      fi
      rm $TMP_DIR/x
    done
  done
}

# delete cluster from EKS, including cloudformation templates
function delete_cluster() {
  cluster=$(get_cluster)
  confirm "Are you sure that you want to delete cluster $cluster?"
  start "deleting cluster $cluster"
  eksctl delete cluster --name=$cluster
  expect_success "Cluster deletion failed."
  info "cluster $cluster deletion takes ~10 minutes to complete"
}

# remove service mesh from cluster and config repo
function remove_mesh() {
  start "removing linkerd"
  linkerd install --ignore-cluster | mykubectl delete -f -
  rm -rf linkerd
  complete "removed linkerd"
}

function create_repo() {
  set -x
  read -p "${GREEN}repo name?${RESET} " -r
  REMOTE_REPO=$REPLY
  DATA='{"name":"yolo-test", "private":"true", "auto_init": true}'
  D=$(echo $DATA | sed -e "s/yolo-test/$REMOTE_REPO/")

  read -p "${GREEN}Is this for an organization? ${RESET}" -r
  if [[ "$REPLY" =~ (y|Y).* ]]; then
    read -r -p $"${GREEN} Name of organization [tidepool-org]?${RESET} " ORG
    ORG=${ORG:-tidepool-org}
    REMOTE_REPO=$ORG/$REMOTE_REPO
    curl "https://api.github.com/orgs/$ORG/repos?access_token=${GITHUB_TOKEN}" -d "$D"
  else
    read -p $"${GREEN} Git user name?${RESET} " -r
    REMOTE_REPO=$REPLY/$REMOTE_REPO
    curl "https://api.github.com/user/repos?access_token=${GITHUB_TOKEN}" -d "$D"
  fi
  info "clone repo using: "
  info "git clone git@github.com:${REMOTE_REPO}.git"
  complete "private repo created"
}

function gloo_dashboard() {
  mykubectl port-forward -n gloo-system deployment/api-server 8081:8080 &
  open -a "Google Chrome" http://localhost:8081
}

function remove_gloo() {
  glooctl install gateway --dry-run | mykubectl delete -f -
}

# await deletion of a CloudFormation template that represents a cluster before returning
function await_deletion() {
  local cluster=$(get_cluster)
  start "awaiting cluster $cluster deletion"
  aws cloudformation wait stack-delete-complete --stack-name eksctl-${cluster}-cluster
  expect_success "Aborting wait"
  complete "cluster $cluster deleted"
}

# migrate secrets from legacy GitHub repo to AWS secrets manager
function migrate_secrets() {
  local cluster=$(get_cluster)
  local secrets=$(get_legacy_values Secret)
  local configmaps=$(get_legacy_values ConfigMap)
  mkdir -p external-secrets
  pushd external-secrets
  echo "$secrets" | external_secret upsert $cluster plaintext | separate_files | add_names
  echo "$configmaps" | separate_files | add_names
  popd
}

function linkerd_dashboard() {
  linkerd dashboard --port 0 &
}

# show help
function help() {
  echo "$0 [-h|--help] (values|edit_values|config|edit_repo|cluster|flux|gloo|regenerate_cert|copy_assets|mesh|migrate_secrets|randomize_secrets|upsert_plaintext_secrets|install_users|deploy_key|delete_cluster|await_deletion|remove_mesh|merge_kubeconfig|gloo_dashboard|linkerd_dashboard|diff|dns|install_certmanager|uninstall_certmanager|mongo_template|linkerd_check|sync|peering|vpc|update_kubeconfig|get_secret|list_secrets|delete_secret|external_secrets)*"
  echo
  echo
  echo "So you want to built a Kubernetes cluster that runs Tidepool. Great!"
  echo "First, create an (empty) configuration repo on GitHub with $0 repo."
  echo "Second, create/edit a configuration file with $0 values."
  echo "Third, gerenate the rest of the configuration with $0 config."
  echo "Fourth, generate the actual AWS EKS cluster with $0 cluster."
  echo "Fifth, install gloo with $0 gloo."
  echo "Sixth, install a service mesh (to encrypt inter-service traffic for HIPPA compliance with $0 mesh"
  echo "Seventh, install the GitOps controller with $0 flux."
  echo "That is it!"
  echo
  echo "----- Basic Commands -----"
  echo "repo    - create config repo on GitHub"
  echo "values  - create initial values.yaml file"
  echo "config  - create K8s and eksctl K8s manifest files"
  echo "cluster - create AWS EKS cluster, add system:master USERS"
  echo "gloo    - install gloo"
  echo "mesh    - install service mesh"
  echo "flux    - install flux GitOps controller, Tiller server, client certs for Helm to access Tiller, and deploy key into GitHub"
  echo "sumo    - install sumologic collector"
  echo
  echo "If you run into trouble or have specific needs, check out these commands:"
  echo
  echo "----- Advanced Commands -----"
  echo "vpc - identify the VPC"
  echo "sync - Cause flux to sync with the config repo."
  echo "peering - List peering relationships"
  echo "edit_repo - open shell with config repo in current directory.  Exit shell to commit changes."
  echo "regenerate_cert - regenerate client certs for Helm to access Tiller"
  echo "edit_values - open editor to edit values.yaml file"
  echo "copy_assets - copy S3 assets to new bucket"
  echo "migrate_secrets - migrate secrets from legacy GitHub repo to AWS secrets manager"
  echo "randomize_secrets - generate random secrets and persist into AWS secrets manager"
  echo "upsert_plaintext_secrets - read STDIN for plaintext K8s secrets"
  echo "install_users - add system:master USERS to K8s cluster"
  echo "deploy_key - copy deploy key from Flux to GitHub config repo"
  echo "delete_cluster - initiate deletion of the AWS EKS cluster"
  echo "await_deletion - await completion of deletion of gthe AWS EKS cluster"
  echo "merge_kubeconfig - copy the KUBECONFIG into the local $KUBECONFIG file"
  echo "install_certmanager - install cert-manager"
  echo "uninstall_certmanager - uninstall cert-manager"
  echo "gloo_dashboard - open the Gloo dashboard"
  echo "dns - update the DNS aliases served"
  echo "linkerd_dashboard - open the Linkerd dashboard"
  echo "linkerd_check - check Linkerd status"
  echo "mongo_template - output a template to use for creating a mongo secret"
  echo "diff - show recent git diff"
  echo "envrc - create .envrc file for direnv to change kubecontexts and to set REMOTE_REPO"
  echo "update_kubeconfig - modify context and user for kubeconfig"
  echo "envoy - show envoy config"
}

if [ $# -eq 0 ]; then
  help
  exit 0
fi

APPROVE=false
CLONE_REMOTE=true
declare -a PARAMS
while (("$#")); do
  case "$1" in
    -y | --approve)
      APPROVE=true
      shift 1
      ;;
    -l | --local)
      CLONE_REMOTE=false
      shift 1
      ;;
    -h | --help)
      help
      exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -* | --*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS+=("$1")
      shift
      ;;
  esac
done

function external_secrets() {
  local cluster=$(get_cluster)
  kubectl get externalsecrets --all-namespaces -o yaml | yq r - -j | jq '.items[] | .secretDescriptor.data[] | .key' | sort | uniq
}

function delete_secret() {
  local cluster=$(get_cluster)
  aws secretsmanager delete-secret --secret-id $cluster/$1/$2
}

function list_secrets() {
  local cluster=$(get_cluster)
  aws secretsmanager list-secrets | jq '.SecretList[].Name' | egrep "^\"$cluster/"
}

# get_secret ${ENVIRONMENT} ${SECRETNAME}
function get_secret() {
  local cluster=$(get_cluster)
  local yaml=$(aws secretsmanager get-secret-value  --secret-id $cluster/$1/$2 | jq '.SecretString | fromjson' | yq r - | sed -e 's/^/    /')
  cat <<!
apiVersion: v1
kind: Secret
type: Opaque
data:
$yaml
metadata:
  name: $2
  namespace: $1
!
}

unset TMP_DIR
unset TEMPLATE_DIR
unset CHART_DIR
unset SM_DIR

define_colors

eval set -- "${PARAMS[*]}"
cmd=$1
shift
case $cmd in
  delete_secret)
    check_remote_repo
    setup_tmpdir
    clone_remote
    delete_secret "$@"
    ;;
  external_secrets)
    external_secrets
    ;;
  get_secret)
    check_remote_repo
    setup_tmpdir
    clone_remote
    get_secret "$@"
    ;;
  list_secrets)
    check_remote_repo
    setup_tmpdir
    clone_remote
    list_secrets "$@"
    ;;
  repo)
    setup_tmpdir
    create_repo
    ;;
  values)
    check_remote_repo
    setup_tmpdir
    clone_remote
    expect_values_not_exist
    set_template_dir
    make_values
    save_changes "Added values"
    ;;
  config)
    check_remote_repo
    setup_tmpdir
    clone_remote
    set_template_dir
    make_config
    make_envrc
    save_changes "Added config packages"
    ;;
  cluster)
    check_remote_repo
    setup_tmpdir
    clone_remote
    set_template_dir
    make_cluster
    merge_kubeconfig
    make_users
    make_envrc
    save_changes "Added cluster and users"
    ;;
  gloo)
    check_remote_repo
    expect_github_token
    setup_tmpdir
    clone_remote
    set_template_dir
    confirm_matching_cluster
    install_gloo
    save_changes "Installed gloo"
    ;;
  flux)
    check_remote_repo
    expect_github_token
    setup_tmpdir
    clone_remote
    set_template_dir
    confirm_matching_cluster
    make_flux
    save_changes "Added flux"
    git pull
    save_ca
    make_cert
    make_key
    make_envrc
    update_flux
    save_changes "Updated flux"
    ;;
  mesh)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    make_mesh
    save_changes "Added linkerd mesh"
    ;;
  edit_values)
    check_remote_repo
    setup_tmpdir
    clone_remote
    set_template_dir
    edit_values
    make_config
    save_changes "Edited values. Updated config."
    ;;
  regenerate_cert)
    check_remote_repo
    setup_tmpdir
    clone_remote
    make_cert
    ;;
  copy_assets)
    check_remote_repo
    make_assets
    ;;
  randomize_secrets)
    check_remote_repo
    setup_tmpdir
    clone_remote
    local cluster=$(get_cluster)
    mkdir -p external-secrets
    (
      cd external-secrets
      randomize_secrets | external_secret upsert $cluster encoded | separate_files | add_names
    )
    save_changes "Added random secrets"
    ;;
  migrate_secrets)
    check_remote_repo
    setup_tmpdir
    clone_remote
    clone_secret_map
    establish_ssh
    migrate_secrets
    save_changes "Added migrated secrets"
    ;;
  upsert_plaintext_secrets)
    check_remote_repo
    setup_tmpdir
    clone_remote
    local cluster=$(get_cluster)
    mkdir -p external-secrets
    (
      cd external-secrets
      external_secret upsert $cluster plaintext | separate_files | add_names
    )
    save_changes "Added plaintext secrets"
    ;;
  install_users)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    make_users
    ;;
  deploy_key)
    check_remote_repo
    setup_tmpdir
    clone_remote
    expect_github_token
    make_key
    ;;
  delete_cluster)
    check_remote_repo
    setup_tmpdir
    clone_remote
    set_template_dir
    confirm_matching_cluster
    delete_cluster
    ;;
  await_deletion)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    await_deletion
    info "cluster deleted"
    ;;
  remove_mesh)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    remove_mesh
    save_changes "Removed mesh."
    ;;
  edit_repo)
    check_remote_repo
    setup_tmpdir
    clone_remote
    edit_config
    save_changes "Manual changes."
    ;;
  merge_kubeconfig)
    check_remote_repo
    setup_tmpdir
    clone_remote
    merge_kubeconfig
    ;;
  remove_gloo)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    remove_gloo
    ;;
  gloo_dashboard)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    gloo_dashboard
    ;;
  linkerd_dashboard)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    linkerd_dashboard
    ;;
  diff)
    check_remote_repo
    setup_tmpdir
    clone_remote
    diff_config
    ;;
  sumo)
    check_remote_repo
    setup_tmpdir
    clone_remote
    install_sumo
    ;;
  dns)
    check_remote_repo
    setup_tmpdir
    clone_remote
    set_template_dir
    update_gloo_service
    save_changes "Updated dns entries"
    ;;
  install_certmanager)
    check_remote_repo
    setup_tmpdir
    clone_remote
    install_certmanager
    ;;
  uninstall_certmanager)
    uninstall_certmanager
    ;;
  mongo_template)
    mongo_template
    ;;
  linkerd_check)
    linkerd check --proxy
    ;;
  sync)
    fluxctl sync
    ;;
  peering)
    check_remote_repo
    setup_tmpdir
    clone_remote
    find_peering_connections
    ;;
  delete_peering)
    check_remote_repo
    setup_tmpdir
    clone_remote
    confirm_matching_cluster
    delete_peering_connections
    ;;
  update_kubeconfig)
    check_remote_repo
    setup_tmpdir
    set_template_dir
    clone_remote
    update_kubeconfig
    save_changes "Updated kubeconfig"
    ;;
  envrc)
    check_remote_repo
    setup_tmpdir
    clone_remote
    make_envrc
    ;;
  vpc)
    check_remote_repo
    setup_tmpdir
    clone_remote
    get_vpc
    ;;
  envoy)
    envoy
    ;;
  *)
    panic "unknown command: $param"
    ;;
esac
