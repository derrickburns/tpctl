local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(config, me) = k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
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

function(config, namespace, pkg) policy(config, lib.package(config, namespace, pkg))
