local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = (
  local bucket = 'tidepool-dremio-%s' % me.config.cluster.metadata.name;
  p.policy() + k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
    [
      p.statement(p.bucketArn(bucket), 's3:ListBucket'),
      p.statement(p.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
    ]
  )
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
