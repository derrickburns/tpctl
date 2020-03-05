local lib = import '../../lib/lib.jsonnet';

local mylib = import 'policy-lib.jsonnet';

local policy(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.asset', mylib.assetBucket(config, namespace));
  mylib.policyAndMetadata(
    'hydrophone',
    namespace,
    mylib.withBucketReadingPolicy(config, env, bucket) + mylib.withEmailPolicy(env)
  )
);

function(config, namespace) policy(config, config.namespaces[namespace], namespace)
