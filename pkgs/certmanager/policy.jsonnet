local iam = import '../../lib/iam.jsonnet';

local policy(namespace) = iam.metadata('cert-manager', namespace) + {
  attachPolicy: {
    Statement: [
      {
        Action: [
          'route53:ChangeResourceRecordSets',
        ],
        Effect: 'Allow',
        Resource: 'arn:aws:route53:::hostedzone/*',
      },
      {
        Action: [
          'route53:GetChange',
          'route53:ListHostedZones',
          'route53:ListResourceRecordSets',
          'route53:ListHostedZonesByName',
        ],
        Effect: 'Allow',
        Resource: '*',
      },
    ],
    Version: '2012-10-17',
  },
};

function(config, namespace) policy(namespace)
