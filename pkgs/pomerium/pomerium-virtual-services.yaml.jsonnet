local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local virtualService(config) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'external',
    },
    name: 'proxy',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'proxy',
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
        },
      ],
    },
  },
};

function(config, prev) virtualService(config)
