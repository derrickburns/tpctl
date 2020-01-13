local lib = import '../../lib/lib.jsonnet';

local linkerd = import '../../pkgs/linkerd/lib.jsonnet';

local gen_namespace(config, namespace) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: namespace,
    labels: {
      'discovery.solo.io/function_discovery': 'disabled',
    },
    annotations: linkerd.annotations(config),
  },
};

function(config, prev, namespace) gen_namespace(config, namespace)
