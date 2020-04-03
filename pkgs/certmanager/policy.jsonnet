local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(namespace) = k8s.metadata('cert-manager', namespace) + p.attachPolicy(
  [
    p.statement('*', 'route53:ListHostedZonesByName'),
    p.statement('arn:aws:route53:::change/*', 'route53:GetChange'),
    p.statement('arn:aws:route53:::hostedzone/*', [
      'route53:ChangeResourceRecordSets',
      'route53:ListResourceRecordSets',
    ]),
  ]
);

function(config, namespace, pkg) policy(namespace)
