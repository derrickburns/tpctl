local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    labels: {
      purpose: "support",
    },
    name: 'helm-operator',
    namespace: 'flux',
  },
  spec: {
    podMetricsEndpoints: [
      {
        targetPort: 3030,
      },
    ],
    selector: {
      matchLabels: {
        app: 'helm-operator',
      },
    },
    namespaceSelector: {
      matchNames: [ 'flux' ]
    },
  },
};

function(config, prev) 
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config)
  else {}
