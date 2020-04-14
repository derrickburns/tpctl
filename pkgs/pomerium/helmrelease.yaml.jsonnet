local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../lib/pom.jsonnet';

local getPoliciesForPackage(config, me) = [
 {
  local port = lib.getElse(sso, 'port', 8080),
  local suffix = if port == 80 then '' else ':%s' % port,
  from: 'https://' + mylib.dnsNameForSso(config, me, sso),
  to: 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local' + suffix,
  allowed_groups: lib.getElse(me, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
  allowed_users: lib.getElse(me, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
  allow_websockets: lib.getElse(me, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true)),
} for sso in pom.ssoList(me) ];

local getPolicy(config) = std.flattenArrays([getPoliciesForPackage(config, pkg) for pkg in global.packagesWithKey(config, 'sso')]);

local helmrelease(config, me) = k8s.helmrelease(me, { version: '5.0.3', repository: 'https://helm.pomerium.io' }) {
  _secretNames:: ['pomerium'],
  _configmapNames:: ['pomerium'],
  local domain = mylib.rootDomain(config),
  spec+: {
    values+: {
      authenticate: {
        idp: {
          serviceAccount: true,
        },
      },
      extraEnv: {
        log_level: lib.getElse(me, 'logLevel', lib.getElse(config, 'general.logLevel', 'info')),
      },
      service: {
        type: 'ClusterIP',
      },
      config: {
        rootDomain: domain,
        existingSecret: $._secretNames[0],
        policy: getPolicy(config),
      },
      forwardAuth: {
        enabled: false,
      },
      ingress: {
        enabled: false,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
