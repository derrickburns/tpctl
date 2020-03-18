local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    name: 'elastic-operator',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) serviceaccount(namespace)
