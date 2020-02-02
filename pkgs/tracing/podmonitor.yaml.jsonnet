local lib = import '../../lib/lib.jsonnet';

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

function(config, prev) 
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config)
  else {}
