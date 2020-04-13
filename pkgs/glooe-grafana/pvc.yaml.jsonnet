local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local persistentvolumeclaim(me) = k8s.pvc(me, '100Mi');

function(config, prev, namespace, pkg) persistentvolumeclaim(lib.package(config, namespace, pkg))
