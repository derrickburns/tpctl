local lib = import '../../lib/lib.jsonnet';

local mylib = import 'policy-lib.jsonnet';

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.asset', mylib.assetBucket(config, me.namespace));
  mylib.policyAndMetadata(
    'hydrophone',
    me.namespace,
    mylib.withBucketReadingPolicy(bucket) + mylib.withEmailPolicy(me)
  )
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))
