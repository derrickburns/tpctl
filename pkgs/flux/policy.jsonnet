local iam = import '../../lib/iam.jsonnet';

local policy(config, namespace) = iam.metadata('flux', namespace) + {
  attachPolicy: {
    Statement: [
      {
        Action: [
          'kms:Decrypt',
          'kms:DescribeKey',
        ],
        Effect: 'Allow',
        Resource: config.general.sops.keys.arn,
      },
    ],
    Version: '2012-10-17',
  },
};

function(config, namespace) policy(config, namespace)
