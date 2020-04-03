local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = k8s.metadata(me.pkg, me.namespace) + p.attachPolicy(
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

function(config, namespace, pkg) policy(lib.package(config, namespace, pkg))
