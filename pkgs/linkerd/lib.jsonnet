local lib = import '../../lib/lib.jsonnet';

local tracing = import '../tracing/lib.jsonnet';

{
  annotations(config)::
    if !lib.getElse(config, 'pkgs.linkerd.enabled', false)
    then {}
    else lib.getElse(config, 'pkgs.linkerd.annotations', {}) + {
      'linkerd.io/inject': 'enabled',
    } + (if lib.getElse(config, 'pkgs.tracing.enabled', false)
         then { 'config.linkerd.io/trace-collector': tracing.address(config) }
         else {}),
}
