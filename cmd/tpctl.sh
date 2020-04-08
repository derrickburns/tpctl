#!/usr/bin/env bash
#
# Configure EKS cluster to run Tidepool services
#

set -e
export FLUX_FORWARD_NAMESPACE=flux
export REVIEWERS="derrickburns pazaan jamesraby todd haroldbernard"
export APPROVE=false
export USE_LOCAL_FILESYSTEM=false
export SKIP_REVIEW=false
export GITHUB_ORG=${GITHUB_ORG:-tidepool-org}

function envoy() {
  glooctl proxy served-config
}

function actual_k8s_version() {
  local cluster=$(get_cluster)
  eksctl get cluster $cluster -o json | jq '.[0].Version'
}

function update_utils() {
  start "updating cordns"
  eksctl utils update-coredns -f config.yaml --approve
  complete "updated cordns"
  start "updating aws-node"
  eksctl utils update-aws-node -f config.yaml --approve
  complete "updated aws-node"
  start "updating kube-proxy"
  eksctl utils update-kube-proxy -f config.yaml --approve
  complete "updated kube-proxy"
}

function create_kmskey() {
  start "creating kms key"
  local cluster=$(get_cluster)
  key=$(aws kms create-key --tags TagKey=cluster,TagValue=$cluster --description "Key for cluster $cluster")
  arn=$(echo $key | yq r - -j | jq '.KeyMetadata.Arn' | sed -e 's/"//g')
  alias="alias/kubernetes-$cluster"
  #aws kms delete-alias --alias-name $alias
  aws kms create-alias --alias-name $alias --target-key-id $arn
  local region=$(get_region)
  local account=$(get_aws_account)
  local pgp=$(get_pgp)

  yq w -i values.yaml general.sops.keys.arn $arn
  expect_success "Could not write arn to values.yaml file"

  cat >.sops.yaml <<EOF
  creation_rules:
     - kms: arn:aws:kms:${region}:${account}:${alias}
       encrypted_regex: '^(data|stringData)$'
       pgp: $pgp
EOF
  complete "created kms key"
}

function vpa() {
  (
    cd $TMP_DIR
    git clone https://github.com/kubernetes/autoscaler.git
    cd autoscaler/vertical-pod-autoscaler
    git pull
    ./hack/vpa-up.sh
  )
}

function get_vpc() {
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
  for id in ids; do
    info "deleting peering connection $id"
    aws ec2 delete-vpc-peering-connection --vpc-peering-connection-id $id
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

function make_envrc() {
  start "creating .envrc"
  local cluster=$(get_cluster)
  if [ -f kubeconfig.yaml ]; then
    local context=$(yq r kubeconfig.yaml current-context)
    echo "kubectx $context" >.envrc
  fi
  echo "export REMOTE_REPO=cluster-$cluster" >>.envrc # XXX fix name
  echo "export FLUX_FORWARD_NAMESPACE=flux" >>.envrc
  add_file ".envrc"
  complete "created .envrc"
}

function cluster_in_repo() {
  yq r kubeconfig.yaml -j current-context | sed -e 's/"//g' -e "s/'//g"
}

function install_glooctl() {
  start "checking glooctl"
  local glooctl_version=$(require_value "pkgs.gloo.version")
  if ! command -v glooctl >/dev/null 2>&1 || [ $(glooctl version -o json | grep Client | yq r - 'Client.version') != ${glooctl_version} ]; then
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
  if ! ssh-add -l &>/dev/null; then
    # Could not open a connection to your authentication agent.

    # Load stored agent connection info.
    test -r ~/.ssh-agent &&
      eval "$(<~/.ssh-agent)" >/dev/null

    if ! ssh-add -l &>/dev/null; then
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

# recoverable error. Show message .
function error() {
  echo >&2 "${RED}[✖] ${1}${RESET}"
}

# irrecoverable error. Show message and exit.
function panic() {
  error ${1}
  kill 0
}

# confirm that previous command succeeded, otherwise panic with message
function expect_success() {
  if [ $? -ne 0 ]; then
    panic "$1"
  fi
}

# show info message
function start() {
  echo >&2 "${GREEN}[i] ${1}${RESET}"
}

# show info message
function complete() {
  echo >&2 "${MAGENTA}[√] ${1}${RESET}"
}

# show info message
function info() {
  echo >&2 "${MAGENTA}[√] ${1}${RESET}"
}

# report that file is being added to config repo
function add_file() {
  echo >&2 "${GREEN}[ℹ] adding ${1}${RESET}"
}

# report all files added to config repo from list given in stdin
function add_names() {
  while read -r line; do
    add_file $line
  done
}

# report renaming of file in config repo
function rename_file() {
  echo >&2 "${GREEN}[√] renaming ${1} ${2}${RESET}"
}

# conform action, else exit
function confirm() {
  if [ "$APPROVE" != "true" ]; then
    local msg=$1
    read -p "${RED}$msg${RESET} " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
      exit 1
    else
      echo >&2
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
  expect_github_token
  local repo=$1
  echo $repo | sed -e "s#https://#https://$GITHUB_TOKEN@#"
}

# clone remote
function clone_remote() {
  if [ "$USE_LOCAL_FILESYSTEM" == "false" ]; then
    cd $TMP_DIR
    if [[ ! -d $(basename $HTTPS_REMOTE_REPO) ]]; then
      start "cloning remote"
      git clone $(repo_with_token $HTTPS_REMOTE_REPO)
      expect_success "Cannot clone $HTTPS_REMOTE_REPO"
      complete "cloned remote"
    fi
    echo $(basename $HTTPS_REMOTE_REPO)
    cd $(basename $HTTPS_REMOTE_REPO)
    git pull
  fi
}

# clone quickstart repo, export TEMPLATE_DIR
function set_template_dir() {
  if [[ ! -d $TEMPLATE_DIR ]]; then
    start "cloning quickstart"
    pushd $TMP_DIR >/dev/null 2>&1
    git clone $(repo_with_token https://github.com/tidepool-org/tpctl)
    if [ -n "$TPCTL_BRANCH" ]; then
      (
        cd tpctl
        git checkout $TPCTL_BRANCH
      )
    fi
    export TEMPLATE_DIR=$(pwd)/tpctl
    popd >/dev/null 2>&1
    complete "cloned quickstart"
  fi
}

# convert values file into json, return name of json file
function get_values() {
  local out=$TMP_DIR/values.json
  if [ ! -f "$out" ]
  then
    yq r values.yaml -j > $out
    if [ $? -ne 0 ]; then
      panic "cannot parse values.yaml"
    fi
  fi
  echo $out
}

# retrieve value from values file, or return the second argument if the value is not found
function default_value() {
  local v=$(yq r values.yaml $1)
  echo ${v:-$2}
}

# retrieve value from values file, or exit if it is not available
function require_value() {
  yq r values.yaml -j $1 2>/dev/null
  if [ $? -ne 0 ]; then
    panic "value $1 not found in values.yaml"
  fi
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
  require_value "general.email"
}

# retrieve AWS KMS Master key ARN
function get_key() {
  require_value "keys.arn"
}

# retrieve PGP digest
function get_pgp() {
  require_value "general.sops.keys.pgp"
}

# retrieve list of AWS environments to create
# retrieve AWS account number
function get_aws_account() {
  require_value "aws.accountNumber"
}

# retrieve full path of tidepool environments
function get_environments_path() {
  yq r values.yaml -p p namespaces.*.tidepool
}

# retrieve names of all namespaces to create
function get_namespaces() {
  yq r values.yaml -p p namespaces.* | sed -e "s/namespaces\.//"
}

# retrieve names of tidepool environments
function get_environments() {
  yq r values.yaml -p p namespaces.*.tidepool | sed -e "s/namespaces\.//" -e "s/\..*//"
}

# retrieve list of K8s system masters
function get_iam_users() {
  yq r values.yaml aws.iamUsers | sed -e "s/- //" -e 's/"//g'
}

# retrieve bucket name or create from convention
function get_bucket() {
  local env=$1
  local kind=$2
  local bucket=$(yq r values.yaml namespaces.${env}.tidepool.buckets.${kind} | sed -e "/^  .*/d" -e s/:.*//)
  if [ "$bucket" == "null" ]; then
    local cluster=$(get_cluster)
    echo "tidepool-${cluster}-${env}-${kind}"
  else
    echo $bucket
  fi
}

# create asset bucket and populate it, if the bucket does not already exist
function make_asset_bucket() {
  local env=$1
  local create=$(yq r values.yaml namespaces.${env}.tidepool.buckets.create | sed -e "/^  .*/d" -e s/:.*//)
  local asset_bucket=$(get_bucket $env asset)
  if ! aws s3 ls s3://$asset_bucket >/dev/null 2>&1; then
    start "creating asset bucket $asset_bucket"
    aws s3 mb s3://$asset_bucket >/dev/null 2>&1
    expect_success "Cannot create asset bucket"
    complete "created asset bucket $asset_bucket"

    start "copying dev assets into $asset_bucket"
    aws s3 cp s3://tidepool-dev-asset s3://$asset_bucket
    expect_success "Cannot cp dev assets to asset bucket"
    complete "created asset bucket $asset_bucket"
  fi
}

# create data bucket if it does not exist
function make_data_bucket() {
  local env=$1
  local data_bucket=$(get_bucket $env data)
  if ! aws s3 ls s3://$data_bucket >/dev/null 2>&1; then
    start "creating data bucket $data_bucket"
    aws s3 mb s3://$data_bucket >/dev/null 2>&1
    expect_success "Cannot create data bucket"
    complete "created data bucket $data_bucket"
  fi
}

# create Tidepool asset and data buckets
function make_buckets() {
  local env
  for env in $(get_environments); do
    make_asset_bucket $env
    make_data_bucket $env
  done
}

# config availability of GITHUB TOKEN in environment
function expect_github_token() {
  if [ -z "$GITHUB_TOKEN" ]; then
    panic "\$GITHUB_TOKEN required. https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line"
  fi
}

# retrieve kubeconfig value
function get_kubeconfig() {
  local kc=$(require_value "general.kubeconfig")
  realpath $(eval "echo $kc")
}

function update_kubeconfig() {
  start "updating kubeconfig"
  local values=$(get_values)
  yq r ./kubeconfig.yaml -j >$TMP_DIR/kubeconfig.yaml
  jsonnet --tla-code-file prev=${TMP_DIR}/kubeconfig.yaml --tla-code-file config="$values" ${TEMPLATE_DIR}/eksctl/kubeconfig.jsonnet | yq r -P - >kubeconfig.yaml
  expect_success "updating kubeconfig failed"
  complete "updated kubeconfig"
}

function recreate_service_account() {
  local cluster=$(get_cluster)
  local namespace=$1
  local name=$2
  start "deleting service account $namespace/$name"
  eksctl delete iamserviceaccount --cluster $cluster --namespace $namespace --name $name || true
  start "awaiting deletion of cloud formation stack for service account"
  aws cloudformation wait stack-delete-complete --stack-name eksctl-${cluster}-addon-iamserviceaccount-${namespace}-${name}
  start "creating new service account"
  eksctl create iamserviceaccount -f config.yaml --approve
  expect_success "eksctl create service account failed."
  complete "recreated service account $namespace/$name, now restart dependent services"
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

function get_valid_packages() {
  if [ -z "$VALID_PACKAGES" ]
  then
    local pkgs=""
    for dir in $(ls $TEMPLATE_DIR/pkgs); do
      local pkg=$(basename $dir)
      pkgs="${pkgs} $pkg"
    done
    VALID_PACKAGES="$pkgs"
  fi
  echo $VALID_PACKAGES
}

# return list of enabled packages
function enabled_pkgs() {
  local key=$1
  local pkgs=""
  for pkg in $(get_valid_packages); do
    local enabled=$(yq r values.yaml $key.${pkg}.enabled)
    if [ "$enabled" == "true" ]; then
      pkgs="${pkgs} $pkg"
    fi
  done
  echo $pkgs
}

# make K8s manifest files for shared services
function make_shared_config() {
  start "creating package manifests"
  cp -r pkgs $TMP_DIR
  rm -rf flux gloo
  rm -rf pkgs
  complete "created package manifests"
}

# make K8s manifests for enviroments given config, path, prefix, and environment name

# make EKSCTL manifest file
function make_cluster_config() {
  local values=$(get_values)
  start "creating eksctl manifest"
  add_file "config.yaml"
  serviceAccountFile=$TMP_DIR/serviceaccounts
  make_policy_manifests | yq r - -j | jq >$serviceAccountFile
  jsonnet --tla-code-file config="$values" --tla-code-file serviceaccounts="$serviceAccountFile" ${TEMPLATE_DIR}/eksctl/cluster_config.jsonnet | yq r -P - >config.yaml
  expect_success "Templating failure eksctl/cluster_config.jsonnet"
  complete "created eksctl manifest"
}

function as_json_else() {
  local source=$1
  local dest=$2
  local default=$3
  mkdir -p $(dirname $dest)
  if [ -f $source ]; then
    yq r $source -j >${dest}
    if [[ $? -ne 0 || $(wc -w <${dest} | sed -e "s/ *//") == 0 ]]; then
      echo "$default" >${dest}
    fi
  else
    echo "$default" >${dest}
  fi
}

# make service accounts  for namespace given config, path, prefix, and environment name
function template_service_accounts() {
  local values=$1
  local path=$2
  local prefix=$3
  local namespace=$4
  for fullpath in $(find $path -type f -print); do
    local filename=${fullpath#$prefix}
    local pkg=$(dirname $filename)
    local dir=pkgs/$namespace/$pkg
    local file=$(basename $filename)
    mkdir -p $dir
    if [ "${filename: -14}" == "policy.jsonnet" ]; then
      local newbasename=${file%.jsonnet}
      local out=$dir/${newbasename}
      add_file ${out}
      jsonnet --tla-code-file config=$values --tla-str namespace=$namespace $fullpath --tla-str pkg="$pkg" | jq '[.]' | yq r - --prettyPrint >$out
      cat $out
      expect_success "Templating failure $dir/$filename"
    fi
  done
}

# template_files $1 $2 $3 $4 - instantiates template for pkg in given namespace
# $1 - json values file  (values file name)
# $2 - the absolute path to the template directory
# $3 - the target namespace for the instantiated templates
# $4 - the name of the package to instantiate
#
# copies files with suffix ".yaml"
# evaluates templates for files with suffix ".yaml.jsonnet"
# lists files created to stderr
#
function template_files() {
  local values=$1
  local absoluteTemplateDir=$2
  local namespace=$3
  local pkg=$4
  local dest=$5

  local absoluteTemplatePkgPath=$absoluteTemplateDir/$4

  for absoluteTemplateFilePath in $(find $absoluteTemplatePkgPath -type f -print); do
    local relativeFilePath=${absoluteTemplateFilePath#$absoluteTemplateDir/}
    local relativeTargetDir=pkgs/$namespace/$(dirname $relativeFilePath)
    local templateBasename=$(basename $relativeFilePath)

    # make the directory to place the new fil in, if it does not exist
    mkdir -p $relativeTargetDir

    if [ "${templateBasename: -5}" == ".yaml" ]; then
      # copy a basic yaml file
      local relativeTarget=$relativeTargetDir/$templateBasename
      add_file $relativeTarget
      cp $absoluteTemplateFilePath $relativeTarget
    elif [ "${templateBasename: -13}" == ".yaml.jsonnet" ]; then
      # instantiate a jsonnet template into yaml
      local targetBasename=${templateBasename%.jsonnet}
      local relativeTarget=$relativeTargetDir/${targetBasename}
      local previousTarget=${TMP_DIR}/$relativeTarget
      add_file ${relativeTarget}
      local tmpPreviousTarget=$TMP_DIR/prev/$relativeTarget
      mkdir -p $(basename $tmpPreviousTarget)
      as_json_else ${previousTarget} $tmpPreviousTarget "{}"
      cat <<! >>$dest
   + (
      local prev=import '$tmpPreviousTarget';
      local config=import '$values';
      local namespace='$namespace';
      local pkg='$pkg';
      local f=import '$absoluteTemplateFilePath';
      { '${relativeTarget}' : f(config, prev, namespace, pkg) }
    )
!
      jsonnet --tla-code-file prev=$tmpPreviousTarget \
              --tla-code-file config=$values \
              --tla-str namespace=$namespace \
              --tla-str pkg=$pkg $absoluteTemplateFilePath | \
              yq r - --prettyPrint >${relativeTarget}
      expect_success "Templating failure ${relativeFilePath}"
      #rm ${tmpPreviousTarget}
    fi
  done
}

# make policy manifests
function make_policy_manifests() {
  local values=$(get_values)
  local ns
  for ns in $(get_namespaces); do
    start "creating $ns policy files "
    local pkg
    for pkg in $(enabled_pkgs namespaces.$ns); do
      template_service_accounts "$values" $TEMPLATE_DIR/pkgs/$pkg $TEMPLATE_DIR/pkgs/ $ns
    done
    complete "created $ns policy files"
  done
}

# make K8s manifests
function make_namespace_config() {
  local values=$(get_values)
  local ns
  local out=$TMP_DIR/output
  echo "{}" >$out
  for ns in $(get_namespaces); do
    start "creating manifests for namespace $ns"
    local pkg
    for pkg in $(enabled_pkgs namespaces.$ns); do
      template_files "$values" $TEMPLATE_DIR/pkgs $ns $pkg $out
    done
    complete "created manifests for namespace $ns"
  done
  #cat $out
  #jsonnet $out
}

# create all K8s manifests and EKSCTL manifest
function make_config() {
  start "creating manifests"
  make_shared_config
  make_cluster_config
  make_namespace_config
  complete "created manifests"
}

# persist changes to config repo in GitHub
function save_changes() {
  git add .
  expect_success "git add failed"
  export GIT_PAGER=/bin/cat
  DIFFS=$(git diff --cached HEAD)
  if [ -z "$DIFFS" ]; then
    info "No changes made"
    return
  fi
  info "==== BEGIN Changes"
  git diff --cached HEAD
  info "==== END Changes"
  local branch="tpctl-$(date '+%Y-%m-%d-%H-%M-%S')"
  establish_ssh
  start "saving changes to config repo"
  read -p "${GREEN}Commit Message [$1]? ${RESET} " -r
  local message=${REPLY:-$1}
  git add .
  expect_success "git add failed"
  if [ "$branch" != "master" ]; then
    git >&2 checkout -b $branch
    expect_success "git checkout failed"
  fi
  expect_success "git checkout failed"
  git commit -m "$message"
  expect_success "git commit failed"
  complete "committed changes to config repo"
  if [ "$SKIP_REVIEW" == true ]; then
    echo "Skipping review"
    git checkout master
    git merge $branch
    git push
    return
  fi
  git push origin $branch
  expect_success "git push failed"
  complete "pushed changes to config repo branch $branch"
  info "Please select PR reviewer: "
  select REVIEWER in none $REVIEWERS; do
    if [ "$REVIEWER" == "none" ]; then
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

function install_helmrelease() {
  local file=$1
  start "bootstrapping $file"
  if ! bash -x helmit $file >${TMP_DIR}/out 2>&1; then
    cat $TMP_DIR/out
    panic "helm upgrade failed"
  fi

  complete "bootstrapped $file"
}

# bootstrap flux
function bootstrap_flux() {
  start "bootstrapping flux"
  establish_ssh
  install_helmrelease pkgs/flux/flux/flux-helmrelease.yaml
  install_fluxkey
  install_helmrelease pkgs/flux/flux/helm-operator-helmrelease.yaml
  complete "bootstrapped flux"
}

# save deploy key to config repo
function install_fluxkey() {
  start "authorizing access to ${GIT_REMOTE_REPO}"

  expect_github_token

  local key=$(fluxctl --k8s-fwd-ns=${FLUX_FORWARD_NAMESPACE} identity 2>${TMP_DIR}/err)

  while [ -s ${TMP_DIR}/err ]; do
    cat ${TMP_DIR}/err
    info "waiting for flux deploy secret to be created"
    sleep 2
    rm -f ${TMP_DIR}/err
    key="$(fluxctl --k8s-fwd-ns=${FLUX_FORWARD_NAMESPACE} identity 2>$TMP_DIR/err || true)"
  done
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

function mykubectl() {
  KUBECONFIG=~/.kube/config kubectl $@
}

function ostype() {
  case "$OSTYPE" in
    darwin*) echo "darwin" ;;
    linux*) echo "linux" ;;
    bsd*) echo "bsd" ;;
    msys*) echo "windows" ;;
    *) echo "unknown: $OSTYPE" ;;
  esac
}

function install_mesh_client() {
  start "checking linkerd client"
  local linkerd_version=$(require_value "pkgs.linkerd.version")
  if ! command -v linkerd >/dev/null 2>&1 || [ $(linkerd version --client --short) != ${linkerd_version} ]; then
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

function make_mesh_with_helm() {
  local linkerd_version=$(require_value "pkgs.linkerd.version")
  install_mesh_client
  step certificate create identity.linkerd.cluster.local $TMP_DIR/ca.crt $TMP_DIR/ca.key --profile root-ca --no-password --insecure
  step certificate create identity.linkerd.cluster.local $TMP_DIR/issuer.crt $TMP_DIR/issuer.key --ca $TMP_DIR/ca.crt --ca-key $TMP_DIR/ca.key --profile intermediate-ca --not-after 8760h --no-password --insecure
  if [[ ${linkerd_version} =~ "edge" ]]; then
    helm repo add linkerd https://helm.linkerd.io/edge
  else
    helm repo add linkerd https://helm.linkerd.io/stable
  fi
  helm repo update
  kubectl create namespace linkerd
  kubectl annotate namespace --overwrite linkerd linkerd.io/admission-webhooks=disabled
  helm upgrade -i linkerd --namespace linkerd --set installNamespace=false \
    --set-file global.identityTrustAnchorsPEM=$TMP_DIR/ca.crt \
    --set-file identity.issuer.tls.crtPEM=$TMP_DIR/issuer.crt \
    --set-file identity.issuer.tls.keyPEM=$TMP_DIR/issuer.key \
    --set identity.issuer.crtExpiry=$(date -d '+8760 hour' +"%Y-%m-%dT%H:%M:%SZ") \
    linkerd/linkerd2
}

# create service mesh
# do NOT add linkerd to GitOps because upgrade path can be complex
function make_mesh() {
  install_mesh_client
  linkerd install --ignore-cluster | kubectl delete -f -
  kubectl delete clusterrole linkerd-linkerd-web-check
  kubectl delete clusterrolebinding linkerd-linkerd-web-check
  linkerd check --pre
  expect_success "Failed linkerd pre-check."
  start "installing mesh"
  linkerd version
  info "linkerd check --pre"

  if [ "$APPROVE" != "true" ]; then
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

# create k8s system master users [IDEMPOTENT]
function make_users() {
  local group=system:masters
  local cluster=$(get_cluster)
  local aws_region=$(get_region)
  local account=$(get_aws_account)

  start "updating system masters"
  declare -A users
  local user
  for user in $(get_iam_users); do
    local arn=arn:aws:iam::${account}:user/${user}
    users[$arn]=true
    if ! eksctl get iamidentitymapping --region=$aws_region --arn=$arn --cluster=$cluster >/dev/null 2>&1; then
      eksctl create iamidentitymapping --region=$aws_region --arn=$arn --group=$group --cluster=$cluster --username=$user
      while [ $? -ne 0 ]; do
        sleep 3
        eksctl create iamidentitymapping --region=$aws_region --arn=$arn --group=$group --cluster=$cluster --username=$user
        info "retrying eksctl create iamidentitymapping"
      done
      info "added $user to cluster $cluster"
    fi
  done

  for arn in $(eksctl get iamidentitymapping --cluster $cluster | grep user | cut -f1); do
    if [ -z "${users[$arn]}" ]; then
      eksctl delete iamidentitymapping --region=$aws_region --arn=$arn --cluster=$cluster --all
      expect_success "Could not delete $arn from cluster $cluster in region $aws_region"
      info "removed $arn from authorized users in cluster $cluster in region $aws_region"
    fi
  done

  complete "updated system masters"
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
general:
  github:
    git: $GIT_REMOTE_REPO
    https: $HTTPS_REMOTE_REPO
!

  #yq r values.yaml -j | jq '.cluster.metadata.name = .general.github.git' |
  #jq '.cluster.metadata.name |= gsub(".*\/"; "")' |
  #jq '.cluster.metadata.name |= gsub("cluster-"; "")' | yq r - >xxx.yaml
  #mv xxx.yaml values.yaml
  if [ "$APPROVE" != "true" ]; then
    ${EDITOR:-vi} values.yaml
  fi
  complete "created values.yaml"
}

# show recent diff
function diff_config() {
  git diff HEAD~1
}

# clone development repo, exports CHART_DIR
function set_chart_dir() {
  if [[ ! -d $CHART_DIR ]]; then
    start "cloning development tools"
    pushd $TMP_DIR >/dev/null 2>&1
    git clone $(repo_with_token https://github.com/tidepool-org/development)
    cd development
    git pull
    CHART_DIR=$(pwd)/charts/tidepool
    popd >/dev/null 2>&1
    complete "cloned development tools"
  fi
}

# get the name of the environment that is being shadowed, return empty string if no such environment
function get_shadow_sender() {
  local env=$1
  local val=$(yq r values.yaml -j namespaces.${env}.tidepool.shadow.enabled | sed -e 's/"//g' -e "s/'//g")
  if [ $? -ne 0 -o "$val" == "null" -o "$val" == "" -o "$val" == "false" ]; then
    echo ""
  fi
  local val=$(yq r values.yaml -j namespaces.${env}.tidepool.shadow.sender | sed -e 's/"//g' -e "s/'//g")
  if [ $? -ne 0 -o "$val" == "null" -o "$val" == "" ]; then
    echo ""
  else
    echo $val
  fi
}

function forward_shadow_secrets() {
  local env
  for env in $(get_environments); do
    local sender=$(get_shadow_sender $env)
    if [[ -n $sender ]]; then
      for file in userdata; do
        if [ ! -f secrets/${env}/${file}.yaml ]; then
          sops -d secrets/${sender}/${file}.yaml | yq w - metadata.namespace $env >secrets/${env}/${file}.yaml
          sops -e -i secrets/${env}/${file}.yaml
        fi
      done
    fi
  done
}

# generate random secrets,  if they do not already exist
function generate_secrets() {
  set_chart_dir
  local cluster=$(get_cluster)
  local env
  mkdir -p secrets
  forward_shadow_secrets
  for env in $(get_environments); do
    start "generating secrets for $env"
    helm template --namespace $env --set gloo.enabled=false --set global.secret.generated=true $CHART_DIR -f $CHART_DIR/values.yaml | select_kind Secret >$TMP_DIR/x.yaml
    local dir=$TMP_DIR/secrets
    mkdir -p $dir
    pushd $dir >/dev/null 2>&1
    separate_by_namespace <$TMP_DIR/x.yaml >/dev/null 2>&1
    popd >/dev/null 2>&1
    for file in $(find $dir -type f -print); do
      b=${file#${TMP_DIR}/}
      if [ ! -f $b ]; then
        mkdir -p $(dirname $b)
        sops --encrypt $file >$b
        add_file $b
      else
        info "$b already exists, skipping"
      fi
    done
    rm $TMP_DIR/x.yaml
    rm -r $dir
    complete "generated secrets for $env"
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

# create an empty GitHub config repo
# name is given in $1
# if name contains a slash, the part before is treated as the organization
# if name does not containa slash, then organization is interpolated from the environment variable $ORG
# if that is unset, then use personal account associated with provided GitHub token.

function make_repo() {
  input="$1"

  local org
  local repo
  local dest

  if [[ "$input" == */* ]]; then
    org=$(echo -n $input | cut -d '/' -f 1)
    repo=$(echo -n $input | cut -d '/' -f 2)
  else
    org=$GITHUB_ORG
    repo=$input
  fi

  if [[ -z $org ]]; then
    dest="https://api.github.com/user/repos"
    export REMOTE_REPO=${GITHUB_USER}/$repo
  else
    dest="https://api.github.com/orgs/$org/repos"
    export REMOTE_REPO=$org/$repo
  fi

  local template='{"name":"yolo-test", "private":"true", "auto_init": true}'
  local args=$(echo $template | sed -e "s/yolo-test/$repo/")

  info "creating private repo $org/$repo"
  curl -H "Authorization: token ${GITHUB_TOKEN}" $dest -d "$args"
  expect_success "Could not create repo $org/$repo"
  complete "created private repo $org/$repo"

  if [ "$USE_LOCAL_FILESYSTEM" == "true" ]; then
    info "cloning repo"
    git clone http://github.com/${org}/${repo}.git
    cd $repo
    info "cloned repo into $(pwd)"
  else
    info "clone repo using: "
    info "git clone http://github.com/${org}/${repo}.git"
  fi
  complete "private repo created"
}

# await deletion of a CloudFormation template that represents a cluster before returning
function await_deletion() {
  local cluster=$(get_cluster)
  start "awaiting cluster $cluster deletion"
  aws cloudformation wait stack-delete-complete --stack-name eksctl-${cluster}-cluster
  expect_success "Aborting wait"
  complete "cluster $cluster deleted"
}

HELP='
----- Repo Commands (safe)
config                              - create K8s and eksctl K8s manifest files
envrc                               - create .envrc file for direnv to change kubecontexts and to set REMOTE_REPO
fluxkey                             - copy public key from Flux to GitHub config repo
repo  \$ORG/\$REPO_NAME             - create config repo on GitHub
secrets                             - generate new secrets for all tidepool environments
sync                                - cause flux to sync with the config repo
values                              - create initial values.yaml file
      
----- Query Commands (safe)
envoy                               - show envoy config
linkerd_check                       - check Linkerd status
peering                             - list peering relationships
vpc                                 - identify the VPC
      
----- Cluster Commands
await_deletion                      - await completion of deletion of the AWS EKS cluster
cluster                             - create AWS EKS cluster, add system:master USERS
delete_cluster                      - (initiate) deletion of the AWS EKS cluster
flux                                - install flux GitOps controller and deploy flux public key into GitHub
mesh                                - install service mesh
service_account \$namespace \$name  - recreate a single service account in current context
users                               - add system:master USERS to K8s cluster
utils                               - update coredns, aws-node, and kube-proxy services in current context
vpa                                 - install vertical pod autoscaler
      
----- Other Commands
buckets                             - create S3 buckets if needed and copy assets if does not exist
kmskey                              - create a new Amazon KMS key for the cluster
merge_kubeconfig                    - copy the KUBECONFIG into the local $KUBECONFIG file
remove_mesh                         - uninstall the service mesh
update_kubeconfig                   - modify context and user for kubeconfig
'

# show help
function help() {
  echo "$HELP"
}


main() {
  declare -a PARAMS
  while (("$#")); do
    case "$1" in
      -y | --approve)
        APPROVE=true
        shift 1
        ;;
      --skip-review)
        SKIP_REVIEW=true
        shift 1
        ;;
      -x)
        set -x
        shift 1
        ;;
      -l | --local)
        USE_LOCAL_FILESYSTEM=true
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

  unset TMP_DIR
  unset TEMPLATE_DIR
  unset CHART_DIR
  unset SM_DIR

  define_colors

  eval set -- "${PARAMS[*]}"
  cmd=${1:-config}
  if [ $# -ne 0 ]; then
    shift
  fi
  case $cmd in
    await_deletion)
      check_remote_repo
      setup_tmpdir
      clone_remote
      confirm_matching_cluster
      await_deletion
      info "cluster deleted"
      ;;
    buckets)
      check_remote_repo
      make_buckets
      ;;
    cluster)
      check_remote_repo
      setup_tmpdir
      clone_remote
      set_template_dir
      make_config
      make_cluster
      merge_kubeconfig
      make_users
      save_changes "Added cluster and users"
      ;;
    config)
      check_remote_repo
      expect_github_token
      setup_tmpdir
      clone_remote
      set_template_dir
      confirm_matching_cluster
      make_config
      save_changes "Added config packages"
      ;;
    delete_cluster)
      check_remote_repo
      setup_tmpdir
      clone_remote
      set_template_dir
      confirm_matching_cluster
      delete_cluster
      ;;
    delete_peering)
      check_remote_repo
      setup_tmpdir
      clone_remote
      confirm_matching_cluster
      delete_peering_connections
      ;;
    envoy)
      envoy
      ;;
    envrc)
      check_remote_repo
      setup_tmpdir
      clone_remote
      make_envrc
      ;;
    flux)
      check_remote_repo
      setup_tmpdir
      set_template_dir
      clone_remote
      make_config
      bootstrap_flux
      confirm_matching_cluster
      ;;
    fluxkey)
      check_remote_repo
      setup_tmpdir
      clone_remote
      expect_github_token
      install_fluxkey
      ;;
    kmskey)
      check_remote_repo
      setup_tmpdir
      clone_remote
      create_kmskey
      save_changes "Added kms key"
      ;;
    linkerd_check)
      linkerd check --proxy
      ;;
    merge_kubeconfig)
      check_remote_repo
      setup_tmpdir
      clone_remote
      merge_kubeconfig
      ;;
    mesh)
      check_remote_repo
      setup_tmpdir
      clone_remote
      confirm_matching_cluster
      make_mesh
      save_changes "Added linkerd mesh"
      ;;
    peering)
      check_remote_repo
      setup_tmpdir
      clone_remote
      find_peering_connections
      ;;
    remove_mesh)
      check_remote_repo
      setup_tmpdir
      clone_remote
      confirm_matching_cluster
      remove_mesh
      save_changes "Removed mesh."
      ;;
    repo)
      setup_tmpdir
      make_repo $@
      check_remote_repo
      setup_tmpdir
      clone_remote
      expect_values_not_exist
      set_template_dir
      make_values
      save_changes "Added values"
      ;;
    secrets)
      check_remote_repo
      setup_tmpdir
      clone_remote
      generate_secrets
      save_changes "Added secrets"
      ;;
    service_account)
      check_remote_repo
      clone_remote
      recreate_service_account $1 $2
      ;;
    sync)
      fluxctl sync
      ;;
    update_kubeconfig)
      check_remote_repo
      setup_tmpdir
      set_template_dir
      clone_remote
      update_kubeconfig
      save_changes "Updated kubeconfig"
      ;;
    users)
      check_remote_repo
      setup_tmpdir
      clone_remote
      confirm_matching_cluster
      make_users
      ;;
    utils)
      check_remote_repo
      clone_remote
      update_utils
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
    vpa)
      check_remote_repo
      setup_tmpdir
      vpa
      ;;
    vpc)
      check_remote_repo
      setup_tmpdir
      clone_remote
      get_vpc
      ;;
    *)
      if command -v fzf >/dev/null 2>&1; then
        choices=$(echo "$HELP" | fzf -f $cmd)
        error "Unknown command: \"$cmd\", perhaps you meant one of these: "
        echo
        echo "$choices"
      else
	panic "Unknown command: $cmd"
      fi
      ;;
  esac
}

main "$@"
