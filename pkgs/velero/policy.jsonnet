local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(config, me) = (
  local bucket = 'k8s-backup-%s' % config.cluster.metadata.name;
  k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
    [
      p.statement(p.bucketArn(bucket), 's3:ListBucket'),
      p.statement(p.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
    ]
  )
);

function(config, namespace, pkg) policy(config, lib.package(config, namespace, pkg))
