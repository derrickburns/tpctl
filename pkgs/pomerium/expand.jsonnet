local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local pomerium = import '../../lib/pomerium.jsonnet';

{
  expand(config, me, namespace, pkg):: 
    me
    +  $.withGateways(config, me, namespace, pkg)
    + $.withVirtualServices(pomerium.rootDomain(config)),

  withVirtualServices(rootDomain):: {
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

  withGateways(config, me, namespace, pkg):: (
    local update(name, x) = { name: name, namespace: namespace } + x;
    { gateways+: std.mapWithKey(update, $.gateways) }
  ),

  gateways:: {
    'pomerium-proxy': {
      enabled: true,
      options+: {
        accessLogging: true,
        healthCheck: true,
        proxyProtocol: true,
        tracing: true,
      },
      proxies: [
        'pomerium-gateway-proxy',
      ],
      selector: {
        protocol: 'http',
        type: 'pomerium',
      },
    },
    'pomerium-proxy-ssl': {
      enabled: true,
      options+: {
        accessLogging: true,
        healthCheck: true,
        proxyProtocol: true,
        ssl: true,
        tracing: true,
      },
      proxies: [
        'pomerium-gateway-proxy',
      ],
      selector: {
        protocol: 'https',
        type: 'pomerium',
      },
    },
  },
}
