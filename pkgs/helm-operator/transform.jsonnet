local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local kustomize  = import '../../lib/kustomize.jsonnet';

local addnamespace(me) = std.map(kustomize.namespace(me.namespace), me.prev);

local transform(me) = k8s.asMap(addnamespace(me));

function(config, prev, namespace, pkg) transform(common.package(config, prev, namespace, pkg))
