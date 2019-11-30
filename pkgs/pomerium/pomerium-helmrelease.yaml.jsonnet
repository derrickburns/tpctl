local lib = import '../../lib/lib.jsonnet';

local getPolicy(config) = (
  local pkgs = config.pkgs;
  [
    {
      local pkg = pkgs[x],
      from: 'https://' + pkg.sso.dnsName,
      to: 'http://' + x + '.' + lib.getElse(pkg, 'namespace', x) + '.svc.cluster.local',
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
      },
      service: {
        type: 'NodePort',
      },
      config: {
        rootDomain: config.pkgs.pomerium.rootDomain,
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
