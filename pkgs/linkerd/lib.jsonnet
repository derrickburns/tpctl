local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';
local tracing = import '../../lib/tracing.jsonnet';

{
  annotations(config)::
    if !global.isEnabled(config, 'linkerd')
    then {}
    else lib.getElse(global.package(config, 'linkerd'), 'annotations', {}) + {
      'linkerd.io/inject': 'enabled',
    } + (if global.isEnabled(config, 'oc-collector') 
         then { 'config.linkerd.io/trace-collector': tracing.address(config) }
         else {}),
}
