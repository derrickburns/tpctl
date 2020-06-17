local common = import '../../lib/common.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';

local policy(me) = (
  basepolicy.policyAndMetadata(
    me.pkg,
    me.namespace,
    basepolicy.attachPolicy([basepolicy.statement('*', 'ses:*')]),
  )
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
