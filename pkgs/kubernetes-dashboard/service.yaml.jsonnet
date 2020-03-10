local robebinding(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        port: 443,
        targetPort: 8443,
      },
    ],
    selector: {
      'k8s-app': 'kubernetes-dashboard',
    },
  },
};

function(config, prev, namespace) rolebinding(namespace)

