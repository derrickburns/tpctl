local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: 'gloo-system',
  },
};

function(config, prev) namespace(config)
