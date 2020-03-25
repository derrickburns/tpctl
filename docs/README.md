# tpctl
`tpctl` is used to create AWS EKS clusters that run the Tidepool services
in a HIPAA compliant way.

## Running tpctl Via Docker

`tpctl` is a bash script that runs `tpctl.sh` in a Docker container. `tpctl.sh` requires a number of tools be installed in its environment.  The Docker container cointains those tools.

However, we need to communicate using ssh.  Using your local `ssh-agent` with Docker is challenging if you are running Docker for Mac. We have not attempted to do so.  

Instead, we run another `ssh-agent` inside a separate Docker container which shares credentials with the container that runs `tpctl.sh`.  This will require you to enter in a passphrase if your SSH credentials are protected by one.

You also need an AWS account with an identity that has the right:
* to create a Kubernetes cluster in EKS, 
* to create secrets in the AWS Secrets Manager; and,
* to create stacks in AWS CloudFormation.

## Run tpctl Natively

You may also run `tpctl.sh` nativel if you first install the required tools. Most of these can be installed  using `'brew bundle  on the following Brewfile on MacOs:

```bash
tap "weaveworks/tap"
brew "awscli"
brew "kubernetes-helm"
brew "eksctl"
brew "kubernetes-cli"
brew "aws-iam-authenticator"
brew "jq"
brew "yq"
brew "derailed/k9s/k9s"
brew "fluxctl"
brew "coreutils"
brew "python3"
brew "hub"
brew "kubecfg"
brew "cfssl"
brew "weaveworks/tap/eksctl"
```

In addition, you will need to install `python3` with three packages:
```bash
pip3 install --upgrade --user awscli boto3 environs
```

You will also need:
```bash
go get github.com/google/go-jsonnet/cmd/jsonnet
```

## Installation
You may pull down the latest version Docker image of `tpctl` from Docker Hub with tag `tidepool/tpctl:latest`.

```bash
docker pull tidepool/tpctl
```

Copy the following to a file called `tpctl` and to make it executable:

```bash
#!/bin/sh

# set defaults
HELM_HOME=${HELM_HOME:-~/.helm}
KUBE_CONFIG=${KUBECONFIG:-~/.kube/config}
AWS_CONFIG=${AWS_CONFIG:-~/.aws}
GIT_CONFIG=${GIT_CONFIG:-~/.gitconfig}
SSH_KEY=${SSH_KEY:-id_rsa}
AGENT_CONTAINER=""

function shutdown_agent {
	docker kill ssh-agent >/dev/null
	docker rm $AGENT_CONTAINER >/dev/null
}

running=$(docker inspect -f '{{.State.Running}}' ssh-agent 2>/dev/null)
if [ $? -ne 0 -o "$running" == "false"  ]
then
	AGENT_CONTAINER=$(docker run -d --name=ssh-agent nardeas/ssh-agent)
	docker run --rm --volumes-from=ssh-agent -v ~/.ssh:/.ssh -it nardeas/ssh-agent ssh-add /root/.ssh/${SSH_KEY}
        trap shutdown_agent EXIT
fi

if [ -z "$GITHUB_TOKEN" ]
then
	echo "GITHUB_TOKEN with repo scope is needed."
	exit 1
fi

mkdir -p $HELM_HOME
if [ ! -f "$KUBE_CONFIG" ]
then
	touch $KUBE_CONFIG
fi

docker run -it \
--volumes-from=ssh-agent \
-e SSH_AUTH_SOCK=/.ssh-agent/socket \
-e GITHUB_TOKEN=${GITHUB_TOKEN} \
-e REMOTE_REPO=${REMOTE_REPO} \
-v ${GIT_CONFIG}:/root/.gitconfig:ro \
-v ${HELM_HOME}:/root/.helm \
-v ${AWS_CONFIG}:/root/.aws:ro \
-v ${KUBE_CONFIG}:/root/.kube/config \
tidepool/tpctl /root/tpctl $*

```

Alternatively, you may build your own local Docker image from the source by cloning the Tidepool `tpctl` repo and running the `cmd/build.sh` script:
```bash
git clone git@github.com:tidepool-org/tpctl
cd cmd
./build.sh
```

Thereafter, you may use the `tpctl` script provided.

## Authentication

`tpctl` interacts with several external services on your behalf.  `tpctl` must authenticate itself.

To do so, `tpctl` must access your credentials stored on your local machine.  This explains the need for the numerous directories that are mounted into the Docker container.  

We explain these in detail below. If the assumptions we make are incorrect for your environment, you may set the environment variables used in the file to match your environment:

```bash
HELM_HOME=${HELM_HOME:-~/.helm}          
KUBE_CONFIG=${KUBECONFIG:-~/.kube/config}
AWS_CONFIG=${AWS_CONFIG:-~/.aws}
GIT_CONFIG=${GIT_CONFIG:-~/.gitconfig}
```

### GitHub 
In order to update your Git configuration repo with the tags of new versions of Docker images that you use, you must provide a [GitHub personal access token](https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line) with repo scope to access private repositories.

```bash
export GITHUB_TOKEN=....
```

### AWS
In order to create and query AWS resources, you must provide access to your AWS credentials. We assume that you store those
credentials in the standard place, 
```
~/.aws/credentials
```

`tpctl` mounts `~/.aws` inside the Docker container to access the credentials.

### Kubernetes
In order to access your Kubernetes cluster, you must provide access to the file that stores your Kubernetes configurations.  We assume that you store that file in:
```
~/.kube/config
```

`tpctl` mounts `~/.kube` inside the Docker container to access that file.

### Helm
In order to provide you access to the Kubernetes cluster via the `helm` client, you must provide access to the directory that stores your `helm` client credentials.  That directory is typically stored at: 
```
~/.helm
```
 `tpctl` populates that directory with a TLS certificate and keys that are needed to communicate with the `helm` installer.

### Git
In order to make Git commits, `tpctl` needs your Git username and email. This is typically stored in:
```
~/.gitconfig
```    
`tpctl` mounts that file.

Check your `~/.gitconfig`.  It must have entries for `email` and `name` such as:
```ini
[user]
	email = derrick@tidepool.org
	name = Derrick Burns
```
If it does not, then add them by running this locally:

```bash
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```   

### SSH
In order to clone the `flux` tool repo, `tpctl` needs access to your GitHub public key.  This is typically stored in:

```
~/.ssh/id_rsa
```

## Execution Environment

Most of the operations of `tpctl` either use or manipulate a GitHub repository.  You may use `tpctl` to configure an existing GitHub repository.  To do so, provide the name of the repository as the *full name* (including `git@`):

```bash
export REMOTE_REPO=git@github.com:tidepool-org/cluster-test1 
```

Alternatively, if you have not already created a GitHub repository you may create one using `tpctl`:
```bash
tpctl repo
```

## Basic Usage

To create a EKS cluster running the Tidepool services with GitOps
and a service mesh that provides HIPAA compliance, you perform
a series of steps:

### Create a GitHub Configuration Repository

This creates an empty *private* GitHub repository for storing the desired state of your EKS
cluster. We call this the *config repo*.
```bash
tpctl repo
```

### Create a Configuration File

This creates a file in your GitHub config repo called `values.yaml` that contains
all the data needed to construct the other Kubernetes configuration files.  Under normal circumstances, this is the *only* file that you will manually edit.

```bash
tpctl values
```

In this file, you find parameters that you may change to customize the installation.  

By default, the cluster name is derived from the GitHub repository name.  You may override it.

In addition, the default `values.yaml` file defines a single Tidepool environment named `qa2`. You must modify this environment or add others.

Importantly, be sure to set the DNS names for your Tidepool services.  Assuming that you have the authority to do so, TLS certificates are automatically generated for the names that your provide and DNS aliases to the DNS names you provide are also created.

### Generate the Configuration

From the  `values.yaml` file  `tpctl`  can generate all the Kubernetes manifest files, the AWS IAM roles and  policies, and the `eksctl` `ClusterConfig` file that is used to build a cluster.  Do this after you have created and edited your `values.yaml` file.  If you edit your `values.yaml` file, rerun this step:

```bash
tpctl config
  ```

### Create an AWS EKS Cluster

Once you have generated the manifest files, you may create your EKS cluster.

```bash
tpctl cluster
```

This step takes *15-20 minutes*, during which time AWS provisions a new EKS cluster.  It will result in a number of AWS Cloudformation stacks being generated. These stacks will have the prefix: `eksctl-${ClusterName}-`.

### Install a Service Mesh

A service mesh encrypt inter-service traffic to ensure that personal health information (PHI) is protected in transit from exposure tounauthorized parties. 

You may install a service mesh as follows.

```bash
tpctl mesh
```

This must be done *before* the next step because the mesh intercepts future requests to install resources into your cluster.  In some cases, it will add a sidecar to your pods. This is called `automatic sidecar injection`. So, if your mesh is not running, those pods will not have a sidecar to encrypt their traffic.  
  
If that happens, install the mesh then delete the pods manually that were added when the mesh was non-operational. 

### Install the Flux GitOps Controller

The Flux GitOps controller keeps your Kubernetes cluster up to date with the contents of the GitHub configuration repo.  It also keeps your GitHub configuration repo up to date with the latest versions of Docker images of your services that are published in Docker Hub.
  
To install the GitOps operator:

```bash
tpctl flux
```

In addition, this command installs the `tiller` server (the counterpart to the `Helm` client) and creates and installs TLS certificates that the Helm client needs to communicate with `tiller` server.

## Common Issues

Sometimes, one of the steps will fail. Most of the time, you can simply retry that step.  However, in the case of `tpctl cluster` and  `tpctl mesh`, certain side-effects 
persist that may impede your progress.  

### Delete a Cluster

To reverse the side-effects of `tpctl cluster`, you may delete your cluster and await the completion of the deletion:

```bash
tpctl delete_cluster await_deletion
```
Deleting a cluster will take roughtly 10 minutes.

### Delete a Service Mesh

To reverse the side-effects of `tpctl mesh`, you may delete your mesh with:

```bash
tpctl remove_mesh
```

## Advanced Usage
In addition to the basic commands above, you may:

### Edit A Configuration File

We do not recommend that you make manual changes to the files in your config repo, *except* the `values.yaml` file. 
  
However, you may access the GitHub configuration repo using standard Git commands.  

### Edit Your values.yaml File

If you need to modify the configuration parameters in the `values.yaml` file, you may do so with standard Git commands to operate on your Git repo. 

### Create and Populate S3 Buckets for Tidepool

If you are launching a new cluster, you must provide S3 assets for email verification.  You may copy the standard assets by using this command:

```bash
tpctl buckets
```

### Generate and Persist Random Secrets

If you are creating a new environment, you can generate a new set of secrets and persist those secrets in AWS Secrets Manager and modify your configuration repot to access those secrets:

```bash
tpctl secrets
```

### Add system:master Users 

If you have additional `system:master` users to add to your cluster, you may add them to your `values.yaml` file and run this command to install them in your cluster:

```bash
tpctl _users
```

This operation is idempotent. 

You may inspect the existing set of users with:
```
kubectl describe configmap -n kube-system aws-auth
```

Here is example output:

```bash
$ kubectl describe configmap -n kube-system aws-auth
Name:         aws-auth
Namespace:    kube-system
Labels:       <none>
Annotations:  <none>

Data
====
mapRoles:
----
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::118346523422:role/eksctl-qatest-nodegroup-ng-1-NodeInstanceRole-1L2G21MV64ISS
  username: system:node:{{EC2PrivateDNSName}}
- groups:
  - system:bootstrappers
  - system:nodes
  rolearn: arn:aws:iam::118346523422:role/eksctl-qatest-nodegroup-ng-kiam-NodeInstanceRole-1TKZB1U4OVJDW
  username: system:node:{{EC2PrivateDNSName}}
- groups:
  - system:masters
  rolearn: arn:aws:iam::118346523422:user/lennartgoedhart-cli
  username: lennartgoedhart-cli
- groups:
  - system:masters
  rolearn: arn:aws:iam::118346523422:user/benderr-cli
  username: benderr-cli
- groups:
  - system:masters
  rolearn: arn:aws:iam::118346523422:user/derrick-cli
  username: derrick-cli
- groups:
  - system:masters
  rolearn: arn:aws:iam::118346523422:user/mikeallgeier-cli
  username: mikeallgeier-cli
```

### Upload Deploy Key To GitHub Config Repo

In order to manipulate your Github config repo, Flux needs to be authorized to do so.  This authorization step is normally performed when `flux` is installed with `tpctl flux`. 
Should  you delete and reinstall Flux manually, it will create a new public key that you must provide to your GitHub repo in order to authenticate Flux and authorize it to modify the repo.  You do that with:

  ```bash
  tpctl fluxkey
  ``` 

You may inspect your Github config repo to see that the key was deployed by going to the `Settings` tab of the config repo and looking under `Deploy Keys`. 

### Initiate Deletion of Your AWS EKS Cluster

If you wish to delete a AWS EKS cluster that you created with `tpctl`, you may do so with:

```bash
tpctl delete_cluster
```

Note that this only starts the process.  The command returns *before* the process has completed.
The entire process may take up to 20 minutes.

### Await Completion Of Deletion Of Your AWS EKS Cluster

To await the completion of the deletion of an AWS EKS cluster, you may do this:

```bash
tpctl await_deletion
```

### Merge/Copy the KUBECONFIG Into the Your Local $KUBECONFIG File

You may change which cluster that `kubectl` accesses by changing the file that is uses to access your cluster or by changing its contents.  That file is identified in the environment variable `KUBECONFIG`.  

If you are only managing a single cluster, then you can simply set that environment variable to point to that file.

However, in the common case that you are manipulating several clusters, it may be inconvenient to change that environment variable every time you want to switch clusters.

To address this common case, a single `KUBECONFIG` file may contain the information needed to access multiple clusters.  It also contains an indication of *which* of those clusters to access.
The latter indicator may be easily modified with the `kubectx` command.

We store a `KUBECONFIG` file in your config repo that only contains the info needed for the associated cluster.

You may merge the `KUBECONFIG` file from your config repo into a local `KUBECONFIG` file called `~/.kube/config` using:

```bash
tpctl merge_kubeconfig
```
Then, you may use `kubectx` to select which cluster to modify.

## Inside The values.yaml File 

Your primary configuration file, `values.yaml`, contains all the information needed to create your Kubernetes cluster and its services.  

### Metadata

The first section of the file contains configuration values that are shared across the cluster or describe the properties of the configuration repo.

This section establishes where the GitHub repo is located.  
```yaml
general:
  email: derrick@tidepool.org
  github:
    git: git@github.com:tidepool-org/cluster-dev
    https: https://github.com/tidepool-org/cluster-dev
  kubeconfig: $HOME/.kube/config
  logLevel: debug
  sops:
    keys:
      arn: arn:aws:kms:us-west-2:118346523422:key/02d4583e-a7be-41c0-b5c0-2a9c569f3c87
      pgp: CDE5317D7CCA7B80294FB32721A60B1450343446
  sso:
    allowed_groups:
      - eng@tidepool.org
```

### AWS Configuration
This section provides the AWS account number and the IAM users who are to 
be granted `system:master` privileges on the cluster:

```yaml
aws:
  accountNumber: 118346523422                # AWS account number
  iamUsers:                                  # AWS IAM users who will be grants system:master privileges to the cluster
  - derrickburns-cli
  - lennartgoedhard-cli
  - benderr-cli
  - jamesraby-cli
  - haroldbernard-cli
```

### Cluster Provisioning Configuration
This sections provides a description of the AWS cluster itself, including its
name, region, size, networking config, and IAM policies.
```yaml
cluster:
  cloudWatch:
    clusterLogging:
      enableTypes:
        - authenticator
        - api
        - controllerManager
        - scheduler
  managedNodeGroups:
    - desiredCapacity: 3
      instanceType: c5.xlarge
      labels:
        role: worker
      maxSize: 7
      minSize: 3
      name: ngm
      tags:
        nodegroup-role: worker
  nodeGroups:
    - desiredCapacity: 3
      instanceType: c5.xlarge
      labels:
        role: worker
      maxSize: 7
      minSize: 3
      name: ng
      tags:
        nodegroup-role: worker
  metadata:
    rootDomain: tidepool.org
    domain: dev.tidepool.org
    name: qa1
    region: us-west-2
    version: auto
  vpc:
    cidr: 10.47.0.0/16

```

### Namespace Configuration

Kubernetes services run in namespaces. Within each namespace, you may configure a set of packages to run:
```yaml
namespaces:
  amazon-cloudwatch:
    cloudwatch-agent:
      enabled: true
    fluentd:
      enabled: true
  cadvisor:
    cadvisor:
      enabled: true
  cert-manager:
    config:
      create: false
    certmanager:
      enabled: true
      global: true
  elastic-system:
    elastic-operator:
      enabled: true
      storage: 20Gi
  external-dns:
    external-dns:
      enabled: true
  flux:
    flux:
      enabled: true
    fluxcloud:
      enabled: true
      username: derrickburns
    fluxrecv:
      enabled: true
      export: true
      sidecar: false
  gloo-system:
    config:
      goldilocks: true
      meshed: true
    gloo:
      enabled: true
      global: true
      proxies:
        gatewayProxy:
          replicas: 2
        internalGatewayProxy:
          replicas: 2
        pomeriumGatewayProxy:
          replicas: 1
      version: 1.3.15
    glooe-monitoring:
      enabled: true
      sso:
        port: 80
        serviceName: glooe-grafana
    glooe-prometheus-server:
      enabled: false
      sso:
        externalName: glooe-metrics
        port: 80
      storage: 64Gi
  goldilocks:
    goldilocks:
      enabled: true
      sso:
        externalName: goldilocks
        serviceName: goldilocks-dashboard
        port: 80
  jaeger-operator:
    jaeger-operator:
      enabled: true
  kube-system:
    config:
      logging: true
      labels:
        config.linkerd.io/admission-webhooks: disabled
    cluster-autoscaler:
      enabled: false
    metrics-server:
      enabled: true
  kubernetes-dashboard:
    kubernetes-dashboard:
      enabled: true
  linkerd:
    config:
      labels:
        config.linkerd.io/admission-webhooks: disabled
        linkerd.io/is-control-plane: "true"
    linkerd:
      enabled: true
      global: true
    linkerd-web:
      enabled: true
      sso:
        port: 8084
  monitoring:
    config:
      goldilocks: true
    grafana:
      enabled: true
      sso:
        port: 80
        serviceName: monitoring-prometheus-operator-grafana
    prometheus:
      enabled: true
      global: true
      sso:
        externalName: metrics
    prometheus-operator:
      alertmanager:
        enabled: false
      enabled: true
      global: true
      grafana:
        enabled: true
    thanos:
      bucket: tidepool-thanos
      enabled: false
  none:
    config:
      create: false
    common:
      enabled: true
  pomerium:
    config:
      meshed: true
    pomerium:
      enabled: true
  reloader:
    reloader:
      enabled: true
  sumologic:
    sumologic:
      enabled: true
  tracing:
    jaeger:
      enabled: true
      sso:
        port: 16686
        serviceName: jaeger-query
        externalName: tracing
    oc-collector:
      enabled: true
    elasticsearch:
      storage: 15Gi
      enabled: true
  velero:
    config:
      create: false
    velero:
      enabled: false
```

### Tidepool Service Configuration
You also provide the configuration of your Tidepool environments in the `namespaces` section:

```yaml
namespaces:
  dev1:
    config:
      logging: true
      meshed: true
    tidepool:
      buckets:
        asset: tidepool-dev1-asset
        data: tidepool-dev1-data
      chart:
        version: 0.4.0
      dnsNames:
        - dev1.dev.tidepool.org
      enabled: true
      gateway:
        domain: dev.tidepool.org
        host: dev1.dev.tidepool.org
      gitops:
        default: glob:master-*
      hpa:
        enabled: false
```
