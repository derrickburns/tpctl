local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrolebinding(me) = lib.E(me, k8s.clusterrolebinding(me));

function(config, prev, namespace, pkg) clusterrolebinding(lib.package(config, namespace, pkg))
