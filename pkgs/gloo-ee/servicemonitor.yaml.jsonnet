local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.k('v1', 'Service') {
  metadata: {
    name: 'gateway-proxy-prometheus',
    namespace: me.namespace,
    labels: {
      'gateway-proxy-prometheus': 'true',
      'gateway-proxy-id': 'gateway-proxy',
    },
  },
  spec: {
    selector: {
      'gateway-proxy-id': 'gateway-proxy',
      'gateway-proxy': 'live',
    },
    ports: [k8s.port(19000, 19000, 'prometheus')],
  },
};

local gatewayProxy(me) = k8s.k('monitoring.coreos.com/v1', 'ServiceMonitor') + k8s.metadata('gateway-proxy', me.namespace) {
  spec+: {
    jobLabel: me.namespace + '/gateway-proxy',
    namespaceSelector: {
      matchNames: [
        me.namespace,
      ],
    },
    selector: {
      matchLabels: {
        'gateway-proxy-id': 'gateway-proxy',
        'gateway-proxy-prometheus': 'true',
      },
    },
    endpoints: [
      { port: 'prometheus', path: '/stats/prometheus' },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'prometheus-operator')
  then [
    service(me),
    gatewayProxy(me),
  ]
  else {}
)