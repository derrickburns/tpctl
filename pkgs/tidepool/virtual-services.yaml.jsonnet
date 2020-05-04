local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';

local expand = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg) (
  gloo.virtualServicesForPackage(common.package(config, prev, namespace, pkg))
)
