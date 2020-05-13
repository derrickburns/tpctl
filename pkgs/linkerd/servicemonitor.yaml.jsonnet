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
    podTargetLabels: [
      'linkerd.io/control-plane-component',
    ],
    podMetricsEndpoints: [
      {
        port: 'linkerd-admin',
        relabelings: [
          {
            sourceLabels: [
              'linkerd_io_control_plane_component',
            ],
            targetLabel: 'component',
          },
          {
            regex: 'linkerd_io_control_plane_component',
            action: 'labeldrop',
          },
        ],
      },
    ],
  },
};

local linkerdProxy(me) = k8s.k('monitoring.coreos.com/v1', 'PodMonitor') + k8s.metadata('linkerd-proxy', me.namespace) {
  spec+: {
    jobLabel: me.namespace + '/linkerd-proxy',
    namespaceSelector: {
      any: true,
    },
    podTargetLabels: [
      'linkerd.io/proxy-deployment',
    ],
    selector: {
      matchLabels: {
        'linkerd.io/control-plane-ns': 'linkerd$',
      },
    },
    podMetricsEndpoints: [
      {
        port: 'linkerd-admin',
        relabelings: [
          {
            sourceLabels: [
              'linkerd_io_proxy_deployment',
            ],
            targetLabel: 'deployment',
          },
          {
            regex: 'linkerd_io_proxy_deployment',
            action: 'labeldrop',
          },
        ],
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'prometheus-operator')
  then [
    linkerdController(me),
    linkerdProxy(me),
  ]
  else {}
)
