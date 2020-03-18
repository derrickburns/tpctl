local service(config, namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'fluxcloud',
    namespace: namespace,
  },
  spec: {
    selector: {
      name: 'fluxcloud',
    },
    ports: [
      {
        protocol: 'TCP',
        port: 80,
        targetPort: 3032,
      },
    ],
  },
};

function(config, prev, namespace, pkg) service(config, namespace)
