local lib = import '../../lib/lib.jsonnet';
local tplib = import 'lib.jsonnet';
local iam = import '../../lib/iam.jsonnet';


{
  values(obj):: [obj[field] for field in std.objectFields(obj)],

  dataBucket(config, namespace):: 'tidepool-%s-%s-data' % [config.cluster.metadata.name, namespace],

  assetBucket(config, namespace):: 'tidepool-%s-%s-asset' % [config.cluster.metadata.name, namespace],

  withBucketWritingPolicy(config, env, bucket):: {
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


  withBucketReadingPolicy(config, env, bucket):: {
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

  withBucketPolicy(config, env, bucket)::
    if tplib.isShadow(env.tidepool)
    then $.withBucketReadingPolicy(config, env, bucket)
    else $.withBucketWritingPolicy(config, env, bucket),

  withEmailPolicy(env)::
    if tplib.isShadow(env.tidepool)
    then {}
    else $.withSESPolicy(),

}
