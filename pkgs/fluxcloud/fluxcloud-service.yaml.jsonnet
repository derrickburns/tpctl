local service(config) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'fluxcloud',
    namespace: 'flux',
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

function(config) service(config)
