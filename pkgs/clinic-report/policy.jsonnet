local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../lib/policy.jsonnet';

local policy(me) = lib.E(me, mylib.policyAndMetadata(me.pkg, me.namespace, mylib.withEmailPolicy()));

function(config, namespace, pkg) policy(lib.package(config, namespace, pkg))
