local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    name: 'flux',
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
        app: 'flux',
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
