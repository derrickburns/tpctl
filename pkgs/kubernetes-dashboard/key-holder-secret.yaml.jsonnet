local secret(namespace) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard-key-holder',
    namespace: namespace,
  },
  type: 'Opaque',
};

function(config, prev, namespace, pkg) secret(namespace)
