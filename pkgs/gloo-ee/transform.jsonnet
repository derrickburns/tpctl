local common = import '../../lib/common.jsonnet';
local kustomize  = import '../../lib/kustomize.jsonnet';

local transform(me) = std.map(kustomize.namespace(me.namespace), me.prev);

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))
