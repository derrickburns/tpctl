local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  attachPolicy(allowed):: {
    attachPolicy+: {
      Statement+: allowed,
      Version: '2012-10-17',
    },
  },

  statement(resources, actions):: {
    Effect: 'Allow',
    Resource: resources,
    Action: actions,
  },

  bucketArn(bucket):: 'arn:aws:s3:::%s' % bucket,

  contentsArn(bucket):: '%s/*' % $.bucketArn(bucket),

  withEmailPolicy():: $.attachPolicy([$.statement('*', 'ses:*')]),

  withBucketWritingPolicy(bucket):: $.attachPolicy([
    $.statement($.bucketArn(bucket), 's3:ListBucket'),
    $.statement($.contentsArn(bucket), ['s3:GetObject', 's3:PutObject', 's3:DeleteObject']),
  ]),


  withBucketReadingPolicy(bucket):: $.attachPolicy([
    $.statement($.bucketArn(bucket), 's3:ListBucket'),
    $.statement($.contentsArn(bucket), 's3:GetObject'),
  ]),

  policyAndMetadata(name, namespace, policy):: policy + k8s.metadata(name, namespace),
}
