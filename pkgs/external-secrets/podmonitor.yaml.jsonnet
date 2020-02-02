local lib = import "../../lib/lib.jsonnet";

local podmonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    name: 'external-secrets',
    namespace: 'external-secrets',
  },
  spec: {
    jobLabel: 'external-secrets',
    podMetricsEndpoints: [
      {
        targetPort: 3001,
      },
    ],
    selector: {
      matchLabels: {
        'app.kubernetes.io/instance' : 'external-secrets',
      },
    },
    namespaceSelector: {
      matchNames: [ "external-secrets" ],
    },
  },
};

function(config, prev) 
  if lib.getElse(config, 'pkgs.prometheus.enabled', false)
  then podmonitor(config)
  else {}
