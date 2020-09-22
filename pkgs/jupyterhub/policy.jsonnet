local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local withBucketWritingPolicy(bucket) = p.attachPolicy([
  p.statement(p.bucketArn(bucket), 's3:ListBucket'),
  p.statement(p.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
]);

local policy(me) = (
  local bucket = lib.getElse(me, 'bucket', 'tidepool-analytics-stagedata');
  p.policyAndMetadata(me.pkg+'-worker', me.namespace, withBucketWritingPolicy(bucket))
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
