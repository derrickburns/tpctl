local lib = import '../../lib/lib.jsonnet';

local podMonitor(config, namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    labels: {
      purpose: 'support',
    },
    name: 'gloo-gateway-proxies',
    namespace: namespace,
  },
  spec: {
    podMetricsEndpoints: [
      {
        path: '/metrics',
        port: 'metrics',
      },
    ],
    namespaceSelector: {
      matchNames: [
        'gloo-system',
      ],
    },
    selector: {
      matchLabels: {
        'gateway-proxy': 'live',
        gloo: 'gateway-proxy',
      },
    },
  },
};

function(config, prev, namespace)
  if lib.getElse(config, 'pkgs.prometheus.enabled', false)
  then podMonitor(config, namespace)
  else {}
