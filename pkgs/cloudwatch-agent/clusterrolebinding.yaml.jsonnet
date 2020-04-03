local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) k8s.clusterrolebinding(lib.package(config, namespace, pkg))
