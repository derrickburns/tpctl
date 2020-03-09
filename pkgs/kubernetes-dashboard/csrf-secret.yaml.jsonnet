local secret(namespace) = {
  apiVersion: 'v1',
  data: {
    csrf: '',
  },
  kind: 'Secret',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard-csrf',
    namespace: namespace,
  },
  type: 'Opaque',
};

function(config, prev, namespace) secret(namespace)
