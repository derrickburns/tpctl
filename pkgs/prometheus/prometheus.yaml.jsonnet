local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local prometheus(config, me) =  k8s.metadata(me.pkg, me.namespace) {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'Prometheus',
  spec: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: config.cluster.metadata.name,
      region: config.cluster.metadata.region,
    },
    externalUrl: 'http://%s.%s' % [me.pkg, me.namespace],  // XXX Check
    podMetadata: {
      labels: {
        instance: me.pkg,
        namespace: me.namespace,
      },
    },
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

function(config, prev, namespace, pkg) prometheus(config, common.package(config, prev, namespace, pkg))
