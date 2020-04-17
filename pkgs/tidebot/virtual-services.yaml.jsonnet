local gloo = import '../../lib/gloo.jsonnet';
local common = import '../../lib/common.jsonnet';

local exp = import '../../lib/expand.jsonnet';

function(config, prev, namespace, pkg) gloo.virtualServicesForPackage(exp.expand(config), 'tidebot', namespace)
