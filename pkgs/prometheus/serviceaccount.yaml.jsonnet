local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    name: 'prometheus',
    namespace: namespace,
  },
};

function(config, prev, namespace) serviceaccount(namespace)