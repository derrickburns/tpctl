local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config) = k8s.helmrelease('cluster-autoscaler', 'kube-system', '6.2.0') {
  spec+: {
    values: {
      autoDiscovery: {
        clusterName: config.cluster.metadata.name,
      },
      awsRegion: config.cluster.metadata.region,
      extraArgs: {
        'scale-down-utilization-threshold': 0.5,
        'skip-nodes-with-local-storage': false,
        'skip-nodes-with-system-pods': false,
        v: 5,
      },
      rbac: {
        create: true,
      },
      serviceMonitor: {
        enabled: lib.getElse(config, 'pkgs.prometheus.enabled', false),
      },
    },
  },
};

function(config, prev) helmrelease(config)
