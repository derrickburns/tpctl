local lib = import '../../lib/lib.jsonnet';

{
  dnsNameForPkg(config, namespace, pkg)::
    lib.getElse(
      config.namespaces[namespace][pkg].sso,
      'dnsName',
      '%s.%s' % [lib.getElse(config.namespaces[namespace][pkg].sso, 'externalName', pkg), config.cluster.metadata.domain]
    ),

  dnsNamesForNamespace(config, namespace, pkgs):: (
    [$.dnsNameForPkg(config, namespace, pkg) for pkg in std.objectFields(pkgs) if std.objectHas(pkgs[pkg], 'sso') && lib.isEnabled(pkgs[pkg])]
  ),

  dnsNames(config):: (
    local dnsNamesFor(namespace, pkgs) = $.dnsNamesForNamespace(config, namespace, pkgs);
    std.flattenArrays(lib.values(std.mapWithKey(dnsNamesFor, config.namespaces)))
  ),

  rootDomain(config, namespace):: lib.getElse(config, 'namespaces.' + namespace + '.pomerium.rootDomain', config.cluster.metadata.domain),

  expand(config, pkg, namespace):: pkg + $.expandPomeriumVirtualServices($.rootDomain(config, namespace)),

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
