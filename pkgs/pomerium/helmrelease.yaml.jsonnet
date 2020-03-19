local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import 'lib.jsonnet';

local getPoliciesForPackage(config, me) = {
  local sso = me.sso,
  local port = lib.getElse(sso, 'port', 8080),
  local suffix = if port == 80 then '' else ':%s' % port,
  from: 'https://' + mylib.dnsNameForPkg(config, me),
  to: 'http://' + lib.getElse(sso, 'serviceName', me.pkg) + '.' + me.namespace + '.svc.cluster.local' + suffix,
  allowed_groups: lib.getElse(me, 'allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
  allowed_users: lib.getElse(me, 'allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
  allow_websockets: lib.getElse(me, 'allow_websockets', lib.getElse(config, 'general.sso.allow_websockets', true))
};

local getPolicy(config) = [getPoliciesForPackage(config, pkg) for pkg in mylib.packagesRequiringSso(config)];

local helmrelease(config, me) = k8s.helmrelease('pomerium', me.namespace, '5.0.3', 'https://helm.pomerium.io') {
  local domain = mylib.rootDomain(config),
  spec+: {
    values: {
      annotations: {
        'secret.reloader.stakater.com/reload': 'pomerium',
        'configmap.reloader.stakater.com/reload': 'pomerium',
      },
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
        existingSecret: 'pomerium',
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
