local lib = import '../../lib/lib.jsonnet';

local linkerd = import '../linkerd/lib.jsonnet';

local Namespace(config, name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: name,
    labels: {
      'discovery.solo.io/function_discovery': 'disabled',
    },
    annotations: linkerd.annotations(config),
  },
};

function(config, prev, namespace) Namespace(config, namespace)
