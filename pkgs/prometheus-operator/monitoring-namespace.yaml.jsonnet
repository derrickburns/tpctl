local Namespace(config, name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    labels: {
      name: name,
    },
    name: name,
  },
};

function(config, prev, namespace) Namespace(config, namespace)
