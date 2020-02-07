local linkerd = import '../linkerd/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'external-secrets',
    labels: {
      'discovery.solo.io/function_discovery': 'disabled',
    },
  },
};

function(config, prev) namespace(config)
