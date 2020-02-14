local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import 'lib.jsonnet';

local getPolicy(config) = (
  local pkgs = config.pkgs;
  [
    {
      local pkg = pkgs[x],
      local port = lib.getElse(pkg, 'sso.port', 8080),
      local suffix = if port == 80 then '' else ':%s' % port,
      from: 'https://' + mylib.dnsNameForName(config, x),
      to: 'http://' + lib.getElse(pkg, 'sso.serviceName', x) + '.' + lib.getElse(pkg, 'namespace', x) + '.svc.cluster.local' + suffix,
      allowed_groups: lib.getElse(pkg, 'sso.allowed_groups', []),
      allowed_users: lib.getElse(pkg, 'sso.allowed_users', []),
      allow_websockets: true,
    }
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso', {}) != {} && lib.getElse(pkgs[x], 'enabled', false)
  ]
);

local helmrelease(config) = k8s.helmrelease('pomerium', 'pomerium', '5.0.3', 'https://helm.pomerium.io') {
  local domain = lib.rootDomain(config),
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
        log_level: lib.getElse(config, 'pkgs.pomerium.logLevel', lib.getElse(config, 'general.logLevel', 'info')),
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
        enabled: lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false),
      },
      ingress: {
        enabled: false,
      },
    },
  },
};

function(config, prev) helmrelease(config)
