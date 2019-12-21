local lib = import '../../lib/lib.jsonnet';

local tracing = import '../../pkgs/tracing/lib.jsonnet';

local gen_namespace(config, namespace) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: namespace,
    labels: {
      'discovery.solo.io/function_discovery': 'disabled',
    },
    annotations: {
      'linkerd.io/inject': if lib.getElse(config, 'pkgs.linkerd.enabled', false) then "enabled" else "disabled",
    } + tracing.tracingAnnotation(config)
  },
};

function(config, prev, namespace) gen_namespace(config, namespace)
