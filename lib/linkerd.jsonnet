local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';
local tracing = import 'tracing.jsonnet';

{
  annotations(me, force=false, skipInboundPorts='')::
    if !global.isEnabled(me.config, 'linkerd')
    then {}
    else
      (if skipInboundPorts != '' then { 'config.linkerd.io/skip-inbound-ports': skipInboundPorts } else {}) +
      lib.getElse(global.package(me.config, 'linkerd'), 'annotations', {}) +
      (if lib.isTrue(me, 'meshed') || force then {
         'linkerd.io/inject': 'enabled',
       } else {}) +
      (if lib.isFalse(me, 'meshed') then {
         'linkerd.io/inject': 'disabled',
       } else {}) +
      if lib.getElse(global.package(me.config, 'linkerd'), 'tracing', false) && lib.getElse(me, 'linkerdTracing', false)
      then { 'config.linkerd.io/trace-collector': tracing.address(me.config) }
      else {},

  metadata(me, force=false):: (
    local annotations = $.annotations(me, force);
    if annotations != {} then {
      metadata+: {
        annotations+: annotations,
      },
    } else {}
  ),
}
