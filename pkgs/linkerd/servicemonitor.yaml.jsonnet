local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local linkerdController(me) = k8s.k('monitoring.coreos.com/v1', 'PodMonitor') + k8s.metadata('linkerd-controller', me.namespace) {
  spec+: {
    jobLabel: me.namespace + '/linkerd-controller',
    namespaceSelector: {
      matchNames: [
        me.namespace,
      ],
    },
    selector: {
      matchLabels: {
        'linkerd.io/control-plane-component': '.*',
      },
    },
    podMetricsEndpoints: [
      { port: 'linkerd-admin' },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'prometheus-operator')
  then [
    linkerdController(me),
  ]
  else {}
)
