local iam = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local policy = import '../../lib/policy.jsonnet';
local tplib = import 'lib.jsonnet';

{
  dataBucket(config, namespace):: 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace],

  assetBucket(config, namespace):: 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace],

  withBucketPolicy(me, bucket)::
    if tplib.isShadow(me)
    then policy.withBucketReadingPolicy(bucket)
    else policy.withBucketWritingPolicy(bucket),
}
