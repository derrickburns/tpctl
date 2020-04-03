local gloo = import '../../lib/gloo.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) gloo.settings(config, lib.package(config, namespace, pkg))
