local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';
local tplib = import 'lib.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local withEmailPolicy(me) =
  if tplib.isShadow(me)
  then {}
  else basepolicy.withEmailPolicy();

local policy(me) = (
  local bucket = lib.getElse(me, 'buckets.asset', mylib.assetBucket(me.config, me.namespace));
  basepolicy.policyAndMetadata(
    'hydrophone',
    me.namespace,
    mylib.withBucketReadingPolicy(bucket) + mylib.withEmailPolicy()
  )
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, 'tidepool'))
