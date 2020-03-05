local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      'kubernetes.io/cluster-service': 'true',
      'kubernetes.io/name': 'Metrics-server',
    },
    name: 'metrics-server',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        port: 443,
        protocol: 'TCP',
        targetPort: 443,
      },
    ],
    selector: {
      'k8s-app': 'metrics-server',
    },
  },
};

function(config, prev, namespace) service(namespace)
