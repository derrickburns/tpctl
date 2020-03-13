// Generate eksctl ClusterConfig file

local lib = import '../lib/lib.jsonnet';

local annotatedNodegroup(config, ng, clusterName) =
  ng {
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

local all(config, serviceaccounts) =
  defaultClusterConfig
  {
    metadata+: {
      name: config.cluster.metadata.name,
      region: lib.getElse(config, 'cluster.metadata.region', 'us-west-2'),
      version: 'auto',
    },
    cloudWatch+: config.cluster.cloudWatch,
    vpc+: lib.getElse(config, 'cluster.vpc', {}),
    nodeGroups+: config.cluster.nodeGroups,
    iam+: lib.getElse(config, 'cluster.iam', {}) + { serviceAccounts+: serviceaccounts },
  } +
  withAnnotatedNodeGroups(config);

function(config, serviceaccounts) all(config, serviceaccounts)
