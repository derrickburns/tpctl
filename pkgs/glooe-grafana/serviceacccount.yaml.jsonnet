local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local serviceaccount(me) = k8s.serviceaccount(me);

function(config, prev, namespace, pkg) serviceaccount(lib.package(config, namespace, pkg))
