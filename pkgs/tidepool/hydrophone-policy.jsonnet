local lib = import '../../lib/lib.jsonnet';
local tplib = import 'lib.jsonnet';
local mylib = import 'policy-lib.jsonnet';

local withEmailPolicy(me) =
  if tplib.isShadow(me)
  then {}
  else {
    attachPolicy+: {
      Statement+: [
        {
          Effect: 'Allow',
          Action: 'ses:*',
          Resource: '*',
        },
      ],
      Version: '2012-10-17',
    },
  };

local policy(config, me) = (
  local bucket = lib.getElse(me, 'buckets.asset', mylib.assetBucket(config, me.namespace));
  mylib.policyAndMetadata(
    'hydrophone',
    me.namespace,
    mylib.withBucketReadingPolicy(bucket) + withEmailPolicy(me)
  )
);

function(config, namespace) policy(config, lib.package(config, namespace, 'tidepool'))
