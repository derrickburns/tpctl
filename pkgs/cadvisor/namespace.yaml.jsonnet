local Namespace(name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: name,
  },
};

function(config, prev, namespace) Namespace(namespace)
