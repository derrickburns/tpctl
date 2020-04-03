local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = (
  local bucket = lib.getElse(me, "bucket", "tidepool-thanos");
  k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
    [
      p.statement(p.bucketArn(bucket), 's3:ListBucket'),
      p.statement(p.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
    ]
  )
);

function(config, namespace, pkg) policy(lib.package(config, namespace, pkg))
