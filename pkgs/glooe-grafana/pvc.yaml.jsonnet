local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local persistentvolumeclaim(me) = k8s.pvc(me, '100Mi');

function(config, prev, namespace, pkg) persistentvolumeclaim(common.package(config, prev, namespace, pkg))
