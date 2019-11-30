local virtualService(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'external',
    },
    name: 'authorize',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'authorize',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: 'pomerium',
      },
      sniDomains: [
        'authorize.%s' % config.pkgs.pomerium.rootDomain,
      ],
    },
    virtualHost: {
      domains: [
        'authorize.%s' % config.pkgs.pomerium.rootDomain,
      ],
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          routeAction: {
            single: {
              upstream: {
                name: 'pomerium-authorize',
                namespace: 'pomerium',
              },
            },
          },
        },
      ],
    },
  },
};

function(config) virtualService(config)
