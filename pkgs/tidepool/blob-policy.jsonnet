local lib = import '../../lib/lib.jsonnet';

local mylib = import 'policy-lib.jsonnet';

local policy(config, env, namespace) = (
  local bucket = lib.getElse(env, 'tidepool.buckets.data', mylib.dataBucket(config, namespace));
  mylib.policyAndMetadata('blob', namespace, mylib.withBucketPolicy(config, env, bucket))
);

function(config, namespace) policy(config, config.namespaces[namespace], namespace)
