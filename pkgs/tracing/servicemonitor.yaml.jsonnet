local servicemonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    name: 'tracing',
  },
  spec: {
    endpoints: [
      {
        port: 8888,
      },
    ],
    selector: {
      matchLabels: {
        app: 'opencesus',
        component: 'oc-collector',
      },
    },
  },
};

function(config, prev) servicemonitor(config)
