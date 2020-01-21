local linkerd = import '../linkerd/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'tracing',
    annotations: linkerd.annotations(config)
  },
};

function(config, prev) namespace(config)
