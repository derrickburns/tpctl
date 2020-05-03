local expand = import '../../lib/expand.jsonnet';
local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  gloo.gateways(me)
)
