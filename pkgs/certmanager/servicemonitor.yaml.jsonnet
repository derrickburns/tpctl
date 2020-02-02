local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    labels: {
      purpose: "support",
    },
    name: 'certmanager',
  },
  spec: {
    endpoints: [
      {
        targetPort: 9402,
      },
    ],
    selector: {
      matchLabels: {
        app: 'cert-manager',
      },
    },
    namespaceSelector: {
      matchNames: [ 'cert-manager' ],
    },
  },
};

function(config, prev) 
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config)
  else {}
