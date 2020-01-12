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
      to: 'http://' + lib.getElse(pkg, 'sso.serviceName', x) + '.' + lib.getElse(pkg, 'namespace', x) + '.svc.cluster.local' + suffix ,
      allowed_groups: lib.getElse(pkg, 'sso.allowed_groups', []),
      allowed_users: lib.getElse(pkg, 'sso.allowed_users', []),
      allow_websockets: true,
    }
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso', {}) != {}
  ]
);

local helmrelease(config) = {
  local domain = lib.rootDomain(config),
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'pomerium',
    namespace: 'pomerium',
  },
  spec: {
    chart: {
      git: 'git@github.com:pomerium/pomerium-helm',
      path: '.',
      ref: 'master',
    },
    releaseName: 'pomerium',
    values: {
      annotations: {
        'secret.reloader.stakater.com/reload': "pomerium",
        'configmap.reloader.stakater.com/reload': "pomerium",
      },
      authenticate: {
        idp: {
          serviceAccount: true,
        },
      },
      service: {
        type: 'NodePort',
      },
      config: {
        rootDomain: domain,
        existingSecret: 'pomerium',
        policy: getPolicy(config),
      },
      forwardauth: {
        enabled: lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false),
      },
      ingress: {
        enabled: false,
      },
    },
  },
};

function(config, prev) helmrelease(config)
