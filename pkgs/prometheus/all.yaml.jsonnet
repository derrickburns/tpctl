local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'services',
        'pods',
        'endpoints',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
  ],
};

local prometheus(me) = k8s.k('monitoring.coreos.com/v1', 'Prometheus') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    enableAdminAPI: false,
    externalLabels: {
      cluster: me.config.cluster.metadata.name,
      region: me.config.cluster.metadata.region,
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
    thanos: if global.isEnabled(me.config, 'thanos') then {
      local thanos = global.package(me.config, 'thanos'),
      objectStorageConfig: {
        key: 'object-store.yaml',
        name: lib.getElse(thanos, 'secret', 'thanos'),
      },
      image: 'quay.io/thanos/thanos:v0.11.0',
      version: 'v0.11.0',
    } else {},
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 9090)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    clusterrole(me),
    k8s.clusterrolebinding(me),
    prometheus(me),
    service(me),
  ]
)
