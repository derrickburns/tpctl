local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      app: 'glooe-grafana',
      chart: 'grafana-4.0.1',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-grafana',
    namespace: namespace,
  },
};

function(config, prev, namespace) serviceaccount(namespace)
