local lib = import '../../lib/lib.jsonnet';

{
  rootDomain(config):: config.cluster.metadata.domain,

  packagesRequiringSso(config):: [
    lib.package(config, namespace, pkg)
    for namespace in std.objectFields(config.namespaces)
    for pkg in std.objectFields(config.namespaces[namespace])
    if std.objectHas(config.namespaces[namespace][pkg], 'sso')
  ],

  dnsNameForPkg(config, me)::
    lib.getElse(me, 'sso.dnsName', '%s.%s' % [ lib.getElse(me, 'sso.externalName', me.pkg), config.cluster.metadata.domain]),

  dnsNames(config):: [$.dnsNameForPkg(config, pkg) for pkg in $.packagesRequiringSso(config)],

  expand(config, pkg, namespace):: pkg + $.expandPomeriumVirtualServices($.rootDomain(config)),

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
