local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    name: 'jaeger-collector',
    namespace: 'tracing',
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
      matchNames: [ 'tracing' ]
    },
  },
};

function(config, prev) servicemonitor(config)
