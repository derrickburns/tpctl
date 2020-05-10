local certmanager = import '../../lib/certmanager.jsonnet';
local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local pomerium = import '../../lib/pomerium.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local tracing = import '../../lib/tracing.jsonnet';

local getPoliciesForPackage(me) = [
  {
    local config = me.config,
    local port = lib.getElse(sso, 'port', 8080),
    local suffix = if port == 80 then '' else ':%s' % port,
    from: 'https://' + pomerium.dnsNameForSso(config, me, sso),
    to: 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local' + suffix,
    allowed_groups: lib.getElse(sso, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
    allowed_users: lib.getElse(sso, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
    allow_websockets: lib.getElse(sso, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true)),
  }
  for sso in pomerium.ssoList(me)
];

local getPolicy(me) = std.flattenArrays([getPoliciesForPackage(pkg) for pkg in global.packagesWithKey(me.config, 'sso')]);

local helmrelease(me) = k8s.helmrelease(me, { version: '8.5.4', repository: 'https://helm.pomerium.io' }) {
  _secretNames:: ['pomerium'],
  _configmapNames:: ['pomerium'],
  local domain = pomerium.rootDomain(me.config),
  spec+: {
    values+: {
      authenticate+: {
        idp+: {
          provider: 'google',
        },
      },
      extraEnv: {
        log_level: lib.getElse(me, 'logLevel', lib.getElse(me.config, 'general.logLevel', 'info')),
      },
      service: {
        type: 'ClusterIP',
      },
      config: {
        forceGenerateSigningKey: true,
        forceGenerateTLS: "true",
        rootDomain: domain,
        existingSecret: $._secretNames[0],
        policy: std.base64(std.manifestJson(getPolicy(me))),
      },
      forwardAuth: {
        enabled: false,
      },
      ingress: {
        enabled: false,
      },
      tracing: if global.isEnabled(me.config, 'jaeger') then {
        provider: 'jaeger',
        jaeger: {
           collector_endpoint: tracing.collector(me),
           agent_endpoint: tracing.agent(me),
        },
      } else {},
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
