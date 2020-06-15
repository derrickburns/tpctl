local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

local servicemonitor(me) = prometheus.servicemonitor(me, 'metrics');

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'prometheus-operator')
  then [
    servicemonitor(me),
  ]
  else {}
)
