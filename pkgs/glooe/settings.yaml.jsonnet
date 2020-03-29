local lib = import '../../lib/lib.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';

function(config, prev, namespace, pkg) gloo.settings(config, lib.package(config, namespace, pkg))
