local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(config, namespace) = k8s.metadata('flux', namespace) + p.attachPolicy(
  p.statement(config.general.sops.keys.arn, [ 'kms:Decrypt', 'kms:DescribeKey' ])
);

function(config, namespace, pkg) policy(config, namespace)
