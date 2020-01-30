local linkerd = import '../linkerd/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'tracing',
  },
};

function(config, prev) namespace(config)
