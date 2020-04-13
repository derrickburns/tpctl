local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      app: 'gloo',
      gloo: 'observability',
    },
    name: 'observability',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) serviceaccount(namespace)
