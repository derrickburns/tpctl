local lib = import '../../lib/lib.jsonnet';
local mylib = import 'policy-lib.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.data', mylib.dataBucket(config, me.namespace));
  basepolicy.policyAndMetadata('blob', me.namespace, mylib.withBucketPolicy(me, bucket))
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))
