local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';

{
  rootDomain(config):: config.cluster.metadata.domain,

  ssoList(me):
    if !std.objectHas(me, 'sso') then []
    else if std.isArray(me.sso) then me.sso
    else [me.sso],

  dnsNameForSso(config, me, sso)::
    lib.getElse(sso, 'dnsName', '%s.%s' % [lib.getElse(sso, 'externalName', me.pkg), config.cluster.metadata.domain]),

  dnsNamesForPkg(config, me):: [$.dnsNameForSso(config, me, sso) for sso in $.ssoList(me)],

  dnsNames(config):: std.flattenArrays([$.dnsNamesForPkg(config, pkg) for pkg in global.packagesWithKey(config, 'sso')]),

  expand(config, me, namespace, pkg):: me + $.expandPomeriumVirtualServices($.rootDomain(config)),

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
