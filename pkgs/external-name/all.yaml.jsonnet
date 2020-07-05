local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  k8s.externalname(me)
)
