local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local httpsVirtualService(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'external',
    },
    name: 'proxy-https',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'proxy-https',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: 'pomerium',
      },
      sniDomains: mylib.dnsNames(config),
    },
    virtualHost: {
      domains: mylib.dnsNames(config),
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
                name: 'pomerium-proxy',
                namespace: 'pomerium',
              },
            },
          },
          options: {
            upgrades: [
              {
                websocket: {
                  enabled: true
                }
              },
            ]
          },
        },
      ],
    },
  },
};

local httpVirtualService(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'http',
      type: 'external',
    },
    name: 'proxy-http',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'proxy-http',
    virtualHost: {
      domains: mylib.dnsNames(config),
      routes: [
        {
          matchers: [
            {
              prefix: '/',
            },
          ],
          redirectAction: {
            httpsRedirect: true,
          },
        },
      ],
    },
  },
};

function(config, prev) std.manifestYamlStream( [ httpsVirtualService(config), httpVirtualService(config) ] )
