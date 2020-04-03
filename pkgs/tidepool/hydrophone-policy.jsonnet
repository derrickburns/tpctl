local lib = import '../../lib/lib.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';
local tplib = import 'lib.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local withEmailPolicy(me) =
  if tplib.isShadow(me)
  then {}
  else basepolicy.withEmailPolicy();

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.asset', mylib.assetBucket(config, me.namespace));
  basepolicy.policyAndMetadata(
    'hydrophone',
    me.namespace,
    basepolicy.withBucketReadingPolicy(bucket) + basepolicy.withEmailPolicy()
  )
);

function(config, namespace, pkg) policy(config, lib.package(config, namespace, 'tidepool'))
