local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = p.policyAndMetadata(me.pkg, me.namespace, p.attachPolicy([p.statement('*', 'ses:*')]), );

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
