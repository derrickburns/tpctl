local lib = import "../../lib/lib.jsonnet";

{

  address(config):: 'oc-collector.tracing.svc.cluster.local:55678',
    
  tracingAnnotation(config)::
    if lib.getElse(config, 'pkgs.tracing.enabled', false)
    then {
      'config.linkerd.io/trace-collector': $.address(config),
    } else {},
}

