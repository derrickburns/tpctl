local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'kube-state-metrics',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-kube-state-metrics',
    namespace: namespace,
  },
};

function(config, prev, namespace) serviceaccount(namespace)
