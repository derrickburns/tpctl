local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('cluster-autoscaler', namespace, '7.1.0') {
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
      image: {
        tag: "v1.14.7",
      },
      rbac+: {
        create: true,
        name: 'cluster-autoscaler',
        serviceAccount: {
          create: false
        },
      },
      fullnameOverride: 'cluster-autoscaler',
      serviceMonitor: {
        enabled: lib.isEnabledAt(config, 'pkgs.prometheusOperator'),
      },
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
