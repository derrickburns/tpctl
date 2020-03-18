local serviceaccount(namespace) = {
  apiVersion: 'v1',
  kind: 'ServiceAccount',
  metadata: {
    labels: {
      app: 'reloader-reloader',
      chart: 'reloader-v0.0.40',
    },
    name: 'reloader',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) serviceaccount(namespace)
