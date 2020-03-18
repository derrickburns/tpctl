local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config, namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    labels: {
      purpose: 'support',
    },
    name: 'tracing',
    namespace: namespace,
  },
  spec: {
    endpoints: [
      {
        targetPort: 8888,
      },
    ],
    selector: {
      matchLabels: {
        app: 'opencensus',
        component: 'oc-collector',
      },
    },
    namespaceSelector: {
      matchNames: [ namespace ],
    },
  },
};

function(config, prev, namespace, pkg)
  if lib.isEnabledAt(config, 'pkgs.prometheusOperator')
  then servicemonitor(config, namespace)
  else {}
