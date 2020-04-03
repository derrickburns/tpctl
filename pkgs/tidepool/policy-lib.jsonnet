local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';
local tplib = import 'lib.jsonnet';

{
  dataBucket(config, namespace):: 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace],

  assetBucket(config, namespace):: 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace],

  withBucketPolicy(me, bucket)::
    if tplib.isShadow(me)
    then $.withBucketReadingPolicy(bucket)
    else $.withBucketWritingPolicy(bucket),

  bucketArn(bucket):: 'arn:aws:s3:::%s' % bucket,

  contentsArn(bucket):: '%s/*' % p.bucketArn(bucket),

  withEmailPolicy():: p.attachPolicy([$.statement('*', 'ses:*')]),

  withBucketWritingPolicy(bucket):: p.attachPolicy([
    p.statement($.bucketArn(bucket), 's3:ListBucket'),
    p.statement($.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
  ]),


  withBucketReadingPolicy(bucket):: p.attachPolicy([
    p.statement($.bucketArn(bucket), 's3:ListBucket'),
    p.statement($.contentsArn(bucket), 's3:GetObject'),
  ]),
}
