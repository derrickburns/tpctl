local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    name: 'metrics-server',
    namespace: namespace,
  },
};

function(config, prev, namespace) serviceaccount(namespace)
