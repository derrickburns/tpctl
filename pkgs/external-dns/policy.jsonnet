local iam = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local policy(me) = iam.metadata(me.pkg, me.namespace) + {
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

function(config, namespace, pkg) policy(lib.package(config, namespace, pkg))
