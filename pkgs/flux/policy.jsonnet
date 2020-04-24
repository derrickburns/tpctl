local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = p.policy() + k8s.metadata('flux', me.namespace) + p.attachPolicy(
  p.statement(me.config.general.sops.keys.arn, [ 'kms:Decrypt', 'kms:DescribeKey' ])
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
