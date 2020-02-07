local lib = import '../../lib/lib.jsonnet';

{
  dnsNameForName(config, name)::
    lib.getElse(
      config.pkgs[name].sso,
      'dnsName',
      '%s.%s' % [lib.getElse(config.pkgs[name].sso, 'externalName', name), config.cluster.metadata.domain]
    ),

  dnsNames(config):: (
    local pkgs = config.pkgs;
    [$.dnsNameForName(config, x) for x in std.objectFields(pkgs) if std.objectHas(pkgs[x], 'sso') && lib.getElse(pkgs[x], 'enabled', false)]
  ),

  rootDomain(config):: lib.getElse(config, 'pkgs.pomerium.rootDomain', config.cluster.metadata.domain),

  expandPomerium(config):: config.pkgs.pomerium + $.expandPomeriumVirtualServices($.rootDomain(config)),

  expandPomeriumVirtualServices(rootDomain):: {
    virtualServices: {
      authenticate: {
        dnsNames: [
          'authenticate.%s' % rootDomain,
        ],
        enabled: true,
        labels: {
          protocol: 'https',
          type: 'pomerium',
        },
      },
      authorize: {
        dnsNames: [
          'authorize.%s' % rootDomain,
        ],
        enabled: true,
        labels: {
          protocol: 'https',
          type: 'pomerium',
        },
      },
      'proxy-https': {
        enabled: true,
        labels: {
          protocol: 'https',
          type: 'pomerium',
        },
      },
      'proxy-http': {
        enabled: true,
        labels: {
          protocol: 'http',
          type: 'pomerium',
        },
      },
    },
  },
}
