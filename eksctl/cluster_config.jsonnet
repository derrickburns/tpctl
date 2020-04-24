// Generate eksctl ClusterConfig file

local lib = import '../lib/lib.jsonnet';
local kubecfg = import 'kubecfg.libsonnet';

local annotatedNodegroup(config, ng, clusterName) =
  ng {
    kubeletExtraConfig: {
      allowedUnsafeSysctls: 'net.netfilter*',
    },
    tags+: {
      'k8s.io/cluster-autoscaler/enabled': 'true',
      ['k8s.io/cluster-autoscaler/' + clusterName]: 'true',
    },
  };

local withAnnotatedNodeGroups(config) = {
  nodeGroups: [annotatedNodegroup(config, ng, config.cluster.metadata.name) for ng in lib.getElse(config, 'cluster.nodeGroups', [])],
  managedNodeGroups: [annotatedNodegroup(config, ng, config.cluster.metadata.name) for ng in lib.getElse(config, 'cluster.managedNodeGroups', [])],
};

local defaultClusterConfig = {
  apiVersion: 'eksctl.io/v1alpha5',
  kind: 'ClusterConfig',
  iam+: {
    withOIDC: true,
  },
};

local strip(k8slist) = std.map( function(c) lib.strip(c, ['apiVersion', 'kind']), k8slist);

local all(config, serviceaccounts) =
  defaultClusterConfig
  {
    metadata+: {
      name: config.cluster.metadata.name,
      region: lib.getElse(config, 'cluster.metadata.region', 'us-west-2'),
      version: lib.getElse(config, 'config.metadata.version', 'auto'),
    },
    cloudWatch+: config.cluster.cloudWatch,
    vpc+: lib.getElse(config, 'cluster.vpc', {}),
    nodeGroups+: config.cluster.nodeGroups,
    iam+: lib.getElse(config, 'cluster.iam', {}) + { serviceAccounts+: strip(serviceaccounts) },
  } +
  withAnnotatedNodeGroups(config);

function(config, serviceaccounts) all(config, std.prune(kubecfg.parseYaml(serviceaccounts)))
