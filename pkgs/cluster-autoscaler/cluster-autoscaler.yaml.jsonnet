local lib = import '../../lib/lib.jsonnet';

local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'true',
    },
    name: 'cluster-autoscaler',
    namespace: 'kube-system',
  },
  spec: {
    chart: {
      name: 'cluster-autoscaler',
      repository: 'https://kubernetes-charts.storage.googleapis.com/',
      version: '6.2.0',
    },
    releaseName: 'cluster-autoscaler',
    values: {
      autoDiscovery: {
        clusterName: config.cluster.metadata.name,
      },
      awsRegion: config.cluster.metadata.region,
      extraArgs: {
        'scale-down-utilization-threshold': 0.5,
        'skip-nodes-with-local-storage': false,
        'skip-nodes-with-system-pods' : false,
        v: 5,
      },
      rbac: {
        create: true,
      },
      serviceMonitor: {
        enabled: lib.getElse(config, 'pkgs.prometheus.enabled', false)
      },
    },
  },
};

function(config, prev) helmrelease(config)
