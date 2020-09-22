local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local basepolicy = import '../../lib/policy.jsonnet';
local mylib = import 'policy.libjsonnet';

local policy(me) = (
  local bucket = lib.getElse(me, 'bucket', 'tidepool-analytics-stagedata');
  basepolicy.policyAndMetadata(me.pkg, me.namespace, mylib.withBucketPolicy(me, bucket))
);

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
