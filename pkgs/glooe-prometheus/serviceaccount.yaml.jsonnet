local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'server',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-server',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) serviceaccount(namespace)
