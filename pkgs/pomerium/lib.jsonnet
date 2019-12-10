local lib = import '../../lib/lib.jsonnet';

{
  dnsName(config, pkg):: lib.getElse(pkg.sso, 'dnsName', '%s.%s' % [ x, config.cluster.metadata.domain ]),

  dnsNames(config):: (
    local pkgs = config.pkgs;
    [ $.dnsName(config, pkgs[x]) for x in std.objectFields(pkgs) if std.objectHas(pkgs[x], 'sso') ]
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
          type: 'external',
        },
      },
      authorize: {
        dnsNames: [
          'authorize.%s' % rootDomain,
        ],
        enabled: true,
        labels: {
          protocol: 'https',
          type: 'external',
        },
      },
      proxy: {
        enabled: true,
        labels: {
          protocol: 'https',
          type: 'external',
        },
      },
    },
  },
}

