local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config, namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    labels: {
      purpose: 'support',
    },
    name: 'certmanager',
    namespace: namespace,
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
      matchNames: ['cert-manager'],
    },
  },
};

function(config, prev, namespace)
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config, namespace)
  else {}
