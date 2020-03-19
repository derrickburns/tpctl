local iam = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tplib = import 'lib.jsonnet';

{
  values(obj):: [obj[field] for field in std.objectFields(obj)],

  dataBucket(config, namespace):: 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace],

  assetBucket(config, namespace):: 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace],

  withBucketWritingPolicy(bucket):: {
    attachPolicy+: {
      Statement+: [
        {
          Effect: 'Allow',
          Action: 's3:ListBucket',
          Resource: 'arn:aws:s3:::%s' % bucket,
        },
        {
          Effect: 'Allow',
          Action: [
            's3:GetObject',
            's3:PutObject',
            's3:DeleteObject',
          ],
          Resource: 'arn:aws:s3:::%s/*' % bucket,
        },
      ],
      Version: '2012-10-17',
    },
  },


  withBucketReadingPolicy(bucket):: {
    attachPolicy+: {
      Statement+: [
        {
          Effect: 'Allow',
          Action: 's3:ListBucket',
          Resource: 'arn:aws:s3:::%s' % bucket,
        },
        {
          Effect: 'Allow',
          Action: [
            's3:GetObject',
          ],
          Resource: 'arn:aws:s3:::%s/*' % bucket,
        },
      ],
      Version: '2012-10-17',
    },
  },

  withSESPolicy():: {
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
  },

  policyAndMetadata(accountName, namespace, policy):: policy + iam.metadata(accountName, namespace),

  withBucketPolicy(me, bucket)::
    if tplib.isShadow(me)
    then $.withBucketReadingPolicy(bucket)
    else $.withBucketWritingPolicy(bucket),

  withEmailPolicy(me)::
    if tplib.isShadow(me)
    then {}
    else $.withSESPolicy(),

}
