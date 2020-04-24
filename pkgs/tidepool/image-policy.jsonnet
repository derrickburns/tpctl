local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local policy(me) = (
  local bucket = lib.getElse(me, 'buckets.data', mylib.dataBucket(me.config, me.namespace));
  basepolicy.policyAndMetadata('image', me.namespace, mylib.withBucketPolicy(me, bucket))
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, 'tidepool'))
