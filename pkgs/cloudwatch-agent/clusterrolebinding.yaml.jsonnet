local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrolebinding(me) = lib.E(me, k8s.clusterrolebinding(me));

function(config, prev, namespace, pkg) clusterrolebinding(common.package(config, prev, namespace, pkg))
