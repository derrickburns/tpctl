local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';

local prometheus(config, namespace) = {
  local ns = config.namespaces[namespace],
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  metadata: {
    name: 'prometheus',
    namespace: namespace,
  },
  spec: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: config.cluster.metadata.name,
      region: config.cluster.metadata.region,
    },
    externalUrl: 'http://prometheus.%s' % namespace, 
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
    thanos: if global.isEnabled(config, 'thanos') then { 
      local thanos = global.package(config, 'thanos'),
      objectStorageConfig: {
        key: 'thanos.yaml',
        name: lib.getElse(thanos, 'secret', 'thanos-objstore-secret'),
      },
      version: 'v0.5.0',
    } else {},
  },
};

function(config, prev, namespace, pkg) prometheus(config, namespace)
