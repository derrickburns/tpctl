local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) serviceaccount(namespace)
