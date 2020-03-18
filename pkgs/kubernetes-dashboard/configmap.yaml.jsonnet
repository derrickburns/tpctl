local configmap(namespace) = {
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard-settings',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) configmap(namespace)
