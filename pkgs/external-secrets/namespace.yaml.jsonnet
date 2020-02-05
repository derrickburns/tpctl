local linkerd = import '../linkerd/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: 'external-secrets',
    annotations: linkerd.annotations(config),
    labels: {
      'discovery.solo.io/function_discovery' : 'disable',
    },
  },
};

function(config, prev) namespace(config)
