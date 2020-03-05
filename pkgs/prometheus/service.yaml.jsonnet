local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'prometheus',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        name: 'http',
        port: 8080,
        protocol: 'TCP',
        targetPort: 9090,
      },
    ],
    selector: {
      app: 'prometheus',
    },
    type: 'ClusterIP',
  },
};

function(config, prev, namespace) service(namespace)
