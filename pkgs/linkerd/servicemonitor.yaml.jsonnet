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
        'linkerd.io/control-plane-ns': 'linkerd',
      },
    },
    podMetricsEndpoints: [
      { port: '4191' },
    ],
  },
};

local servicemonitor(me) = k8s.k('monitoring.coreos.com/v1', 'ServiceMonitor') + k8s.metadata('linkerd-federate', me.namespace) {
  spec+: {
    endpoints: [
      {
        honorLabels: true,
        interval: '30s',
        params: {
          'match[]': [
            '{job="linkerd-proxy"}',
            '{job="linkerd-controller"}',
          ],
        },
        path: '/federate',
        port: 'admin-http',
        relabelings: [
          {
            action: 'keep',
            regex: '^prometheus$',
            sourceLabels: [
              '__meta_kubernetes_pod_container_name',
            ],
          },
        ],
        scrapeTimeout: '30s',
      },
    ],
    jobLabel: 'app',
    namespaceSelector: {
      matchNames: [
        me.namespace,
      ],
    },
    selector: {
      matchLabels: {
        'linkerd.io/control-plane-component': 'prometheus',
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'prometheus-operator')
  then [
    servicemonitor(me),
    linkerdController(me),
  ]
  else {}
)
