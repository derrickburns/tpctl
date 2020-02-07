local lib = import '../../lib/lib.jsonnet';

local prometheus(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  metadata: {
    name: 'prometheus',
    namespace: 'monitoring',
  },
  spec: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: config.cluster.metadata.name,
      region: config.cluster.metadata.region,
    },
    externalUrl: 'http://prometheus.monitoring',
    podMonitorSelector: {
      matchLabels: {},
    },
    podMonitorNamespaceSelector: {
      matchLabels: {},
    },
    resources: {
      requests: {
        memory: '400Mi',
      },
    },
    serviceAccountName: 'prometheus',
    serviceMonitorNamespaceSelector: {
      matchLabels: {},
    },
    serviceMonitorSelector: {
      matchLabels: {},
    },
    thanos: if lib.isTrue(config, 'pkgs.thanos.enabled') then {
      objectStorageConfig: {
        key: 'thanos.yaml',
        name: config.pkgs.thanos.secret,
      },
      version: 'v0.5.0',
    } else {},
  },
};

function(config, prev) prometheus(config)
