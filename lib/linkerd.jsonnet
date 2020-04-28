local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';
local tracing = import 'tracing.jsonnet';

{
  annotations(me,force=false)::
    if !global.isEnabled(me.config, 'linkerd')
    then {}
    else lib.getElse(global.package(me.config, 'linkerd'), 'annotations', {}) + {
      'linkerd.io/inject': if lib.isTrue(me, 'meshed') || force then 'enabled' else 'disabled'
    } + (if global.isEnabled(me.config, 'oc-collector')
         then { 'config.linkerd.io/trace-collector': tracing.address(me.config) }
         else {}),

  metadata(me):: {
    metadata+: {
      annotations+: $.annotations(me),
    },
  },
}
