local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = lib.E(me, k8s.metadata('cert-manager', me.namespace) + p.attachPolicy(
  [
    p.statement('arn:aws:route53:::hostedzone/*', 'route53:ChangeResourceRecordSets'),
    p.statement('*', [
      'route53:GetChange',
      'route53:ListHostedZones',
      'route53:ListResourceRecordSets',
      'route53:ListHostedZonesByName',
    ]),
  ]
));

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
