local iam = import '../../lib/k8s.jsonnet';

local policy(namespace) = iam.metadata('cert-manager', namespace) + {
  attachPolicy: {
    Statement: [
      {
        Effect: 'Allow',
        Action: 'route53:GetChange',
        Resource: 'arn:aws:route53:::change/*',
      },
      {
        Effect: 'Allow',
        Action: [
          'route53:ChangeResourceRecordSets',
          'route53:ListResourceRecordSets',
        ],
        Resource: 'arn:aws:route53:::hostedzone/*',
      },
      {
        Effect: 'Allow',
        Action: 'route53:ListHostedZonesByName',
        Resource: '*',
      },
    ],
    Version: '2012-10-17',
  },
};

function(config, namespace, pkg) policy(namespace)
