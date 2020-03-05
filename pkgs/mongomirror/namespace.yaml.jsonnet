local Namespace(name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'mongomirror',
  },
};

function(config, prev, namespace) Namespace(namespace)
