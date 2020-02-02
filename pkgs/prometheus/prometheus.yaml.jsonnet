local lib = import "../../lib/lib.jsonnet";

local prometheus(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  metadata: {
    name: 'prometheus',
  },
  spec: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: config.cluster.metadata.name,
      region: config.cluster.metadata.region,
    },
    resources: {
      requests: {
        memory: '400Mi',
      },
    },
    serviceAccountName: 'prometheus',
    serviceMonitorNamespaceSelector: {}
    serviceMonitorSelector: {},
    thanos: {
      objectStorageConfig: {
        key: 'thanos.yaml',
        name: config.pkgs.thanos.secret,
      },
      version: 'v0.5.0',
    },
  },
};

function(config, prev) prometheus(config)
