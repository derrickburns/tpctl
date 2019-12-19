local lib = import "../../lib/lib.jsonnet";

{
  tracingAnnotation(config)::
    if lib.getElse(config, 'pkgs.tracing.enabled', false)
    then {
      'config.linkerd.io/trace-collector': 'oc-collector.tracing:55678',
    } else {},
}

