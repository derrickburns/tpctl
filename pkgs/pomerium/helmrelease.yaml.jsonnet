local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import 'lib.jsonnet';

local getPoliciesForNamespace(config, namespace) = (
  local ns = config.namespaces[namespace];
  [
    {
      local pkg = ns[x],
      local port = lib.getElse(pkg, 'sso.port', 8080),
      local suffix = if port == 80 then '' else ':%s' % port,
      from: 'https://' + mylib.dnsNameForPkg(config, namespace, x),
      to: 'http://' + lib.getElse(pkg, 'sso.serviceName', x) + '.' + namespace + '.svc.cluster.local' + suffix,
      allowed_groups: lib.getElse(pkg, 'sso.allowed_groups', lib.getElse(config, 'general.sso.allowed_groups', [])),
      allowed_users: lib.getElse(pkg, 'sso.allowed_users', lib.getElse(config, 'general.sso.allowed_users', [])),
      allow_websockets: true,
    }
    for x in std.objectFields(ns)
    if lib.getElse(ns[x], 'sso', {}) != {} && lib.getElse(ns[x], 'enabled', false)
  ]
);

local getPolicy(config) = std.flattenArrays([getPoliciesForNamespace(config, ns) for ns in std.objectFields(config.namespaces)]);

local helmrelease(config, namespace) = k8s.helmrelease('pomerium', namespace, '5.0.3', 'https://helm.pomerium.io') {
  local me = config.namespaces[namespace].pomerium,
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

function(config, prev, namespace) helmrelease(config, namespace)