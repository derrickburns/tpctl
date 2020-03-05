local linkerd = import '../linkerd/lib.jsonnet';

local Namespace(config, name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: name,
  },
};

function(config, prev, namespace) Namespace(config, namespace)
