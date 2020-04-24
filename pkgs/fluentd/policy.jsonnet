local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(config, me) = p.policy() + k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
  p.statement(
    [
      'arn:aws:logs:%s:%s:*' % [config.cluster.metadata.region, config.aws.accountNumber],
      'arn:aws:s3:::*',
    ],
    [
      'logs:*',
      's3:GetObject',
    ]
  )
);

function(config, prev, namespace, pkg) policy(config, common.package(config, prev, namespace, pkg))
