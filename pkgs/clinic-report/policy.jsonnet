local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = mylib.policyAndMetadata(me.pkg, me.namespace, p.attachPolicy([p.statement('*', 'ses:*')]), );

function(config, namespace, pkg) policy(lib.package(config, namespace, pkg))
