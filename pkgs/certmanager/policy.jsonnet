local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local p = import '../../lib/policy.jsonnet';

local policy(me) = lib.E(me, k8s.metadata('cert-manager', me.namespace) + p.attachPolicy(
  [
    p.statement('*', 'route53:ListHostedZonesByName'),
    p.statement('arn:aws:route53:::change/*', 'route53:GetChange'),
    p.statement('arn:aws:route53:::hostedzone/*', [
      'route53:ChangeResourceRecordSets',
      'route53:ListResourceRecordSets',
    ]),
  ]
));

function(config, prev, namespace, pkg) policy(common.package(config, prev, namespace, pkg))
