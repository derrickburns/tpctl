local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      app: 'opencensus',
      component: 'oc-collector',
    },
    name: 'oc-collector',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        name: 'opencensus',
        port: 55678,
        protocol: 'TCP',
        targetPort: 55678,
      },
      {
        name: 'zipkin',
        port: 9411,
        protocol: 'TCP',
        targetPort: 9411,
      },
      {
        name: 'metrics',
        port: 8888,
        protocol: 'TCP',
        targetPort: 8888,
      },
    ],
    selector: {
      component: 'oc-collector',
    },
  },
};

function(config, prev, namespace, pkg) service(namespace)
