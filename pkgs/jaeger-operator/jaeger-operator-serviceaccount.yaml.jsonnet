local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    name: 'jaeger-operator',
    namespace: namespace,
  },
};

function(config, prev, namespace) serviceaccount(namespace)
