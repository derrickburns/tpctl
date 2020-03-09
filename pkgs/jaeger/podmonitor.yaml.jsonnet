local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config, namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    labels: {
      purpose: 'support',
    },
    name: 'jaeger-collector',
    namespace: namespace,
  },
  spec: {
    podMetricsEndpoints: [
      {
        port: 'admin-http',
      },
    ],
    selector: {
      matchLabels: {
        app: 'jaeger',
        'app.kubernetes.io/component': 'collector',
      },
    },
    namespaceSelector: {
      matchNames: [ namespace ],
    },
  },
};

function(config, prev, namespace)
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config, namespace)
  else {}
