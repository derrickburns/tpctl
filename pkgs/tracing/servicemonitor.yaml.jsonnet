local lib = import '../../lib/lib.jsonnet';

local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    name: 'tracing',
  },
  spec: {
    endpoints: [
      {
        targetPort: 8888,
      },
    ],
    selector: {
      matchLabels: {
        app: 'opencesus',
        component: 'oc-collector',
      },
    },
    namespaceSelector: {
      matchNames: [ "tracing" ],
    },
  },
};

function(config, prev)
  if lib.isTrue(config, 'pkgs.prometheus.enabled')
  then servicemonitor(config)
  else {}
