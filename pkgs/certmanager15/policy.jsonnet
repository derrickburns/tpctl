local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(namespace) = iam.metadata('cert-manager', namespace) + p.attachPolicy(
  [
    p.statement('arn:aws:route53:::hostedzone/*', 'route53:ChangeResourceRecordSets'),
    p.statement('*', [
      'route53:GetChange',
      'route53:ListHostedZones',
      'route53:ListResourceRecordSets',
      'route53:ListHostedZonesByName',
    ]),
  ]
);

function(config, namespace, pkg) policy(namespace)
