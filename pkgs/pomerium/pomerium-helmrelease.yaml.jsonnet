local lib = import '../../lib/lib.jsonnet';

local domain = lib.getElse(config, 'pkgs.pomerium.rootDomain', config.cluster.metadata.domain);

local getPolicy(config) = (
  local pkgs = config.pkgs;
  [
    {
      local pkg = pkgs[x],
      local port = lib.getElse(pkg, 'sso.port', 8080),
      local suffix = if port == 80 then '' else ':%s' % port,
      from: 'https://' + pkg.sso.dnsName,
      to: 'http://' + x + '.' + lib.getElse(pkg, 'namespace', x) + '.svc.cluster.local' + suffix ,
      allowed_groups: lib.getElse(pkg, 'sso.allowed_groups', []),
      allowed_users: lib.getElse(pkg, 'sso.allowed_users', []),
    }
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso.dnsName', '') != ''
  ]
);

local helmrelease(config) = {
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
      service: {
        type: 'NodePort',
      },
      config: {
        rootDomain: domain,
        existingSecret: 'pomerium',
        policy: getPolicy(config),
      },
      ingress: {
        enabled: false,
      },
    },
  },
};

function(config, prev) helmrelease(config)
