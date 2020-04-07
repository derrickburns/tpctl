local global = import '../../lib/global.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local prometheus(config, me) = {
  local ns = config.namespaces[me.namespace],
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  metadata: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: config.cluster.metadata.name,
      region: config.cluster.metadata.region,
    },
    externalUrl: 'http://%s.%s' % [me.pkg, me.namespace],  // XXX Check
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
    serviceAccountName: me.pkg,
    serviceMonitorNamespaceSelector: {
      matchLabels: {},
    },
    serviceMonitorSelector: {
      matchLabels: {},
    },
    thanos: if global.isEnabled(config, 'thanos') then {
      local thanos = global.package(config, 'thanos'),
      objectStorageConfig: {
        key: 'object-store.yaml',
        name: lib.getElse(thanos, 'secret', 'thanos'),
      },
      image: 'quay.io/thanos/thanos:v0.11.0',
      version: 'v0.11.0',
    } else {},
  },
};

function(config, prev, namespace, pkg) prometheus(config, lib.package(config, namespace, pkg))
