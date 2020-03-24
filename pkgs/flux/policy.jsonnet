local iam = import '../../lib/k8s.jsonnet';

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

function(config, namespace, pkg) policy(config, namespace)
