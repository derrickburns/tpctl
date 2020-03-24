local lib = import '../../lib/lib.jsonnet';
local tplib = import 'lib.jsonnet';
local policy = import '../../lib/policy.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local withEmailPolicy(me) =
  if tplib.isShadow(me)
  then {}
  else policy.withEmailPolicy();

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.asset', mylib.assetBucket(config, me.namespace));
  policy.policyAndMetadata(
    'hydrophone',
    me.namespace,
    policy.withBucketReadingPolicy(bucket) + policy.withEmailPolicy(me)
  )
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))
