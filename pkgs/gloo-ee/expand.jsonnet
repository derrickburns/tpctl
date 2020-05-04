local lib = import '../../lib/lib.jsonnet';

{
  expand(config, me, namespace, pkg):: me + $.withGateways(config, me, namespace, pkg),

  withGateways(config, me, namespace, pkg):: {
    local update(name, x) = { name: name, namespace: namespace } + x,
    gateways+: std.mapWithKey(update, $.gateways),
  },

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

        'gateway-proxy'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            healthCheck: true,
            proxyProtocol: true,
            tracing: true,
          },
          proxies: [
            'gateway-proxy',
          ],
          selector: {
            protocol: 'http',
            type: 'external',
          },
        },
        'gateway-proxy-ssl'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            healthCheck: true,
            proxyProtocol: true,
            ssl: true,
            tracing: true,
          },
          proxies: [
            'gateway-proxy',
          ],
          selector: {
            protocol: 'https',
            type: 'external',
          },
        },
        'internal-gateway-proxy'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            tracing: true,
          },
          proxies: [
            'internal-gateway-proxy',
          ],
          selector: {
            protocol: 'http',
            type: 'internal',
          },
        },
        'internal-gateway-proxy-ssl'+: {
          enabled: true,
          options+: {
            accessLogging: true,
            ssl: true,
            tracing: true,
          },
          proxies: [
            'internal-gateway-proxy',
          ],
          selector: {
            protocol: 'https',
            type: 'internal',
          },
        },
      },

}
