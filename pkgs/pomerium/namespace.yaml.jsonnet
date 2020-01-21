local linkerd = import '../linkerd/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'pomerium',
    annotations: linkerd.annotations(config)
  },
};

function(config, prev) namespace(config)
