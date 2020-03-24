local iam = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  withEmailPolicy():: {
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

  policyAndMetadata(name, namespace, policy):: policy + iam.metadata(name, namespace),
}
