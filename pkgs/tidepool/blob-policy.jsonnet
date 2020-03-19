local lib = import '../../lib/lib.jsonnet';

local mylib = import 'policy-lib.jsonnet';

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.data', mylib.dataBucket(config, me.namespace));
  mylib.policyAndMetadata('blob', me.namespace, mylib.withBucketPolicy(me, bucket))
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))
