local gloo = import '../../lib/gloo.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) gloo.settings(config, common.package(config, prev, namespace, pkg))
