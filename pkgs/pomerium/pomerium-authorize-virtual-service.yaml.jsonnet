local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local virtualService(config) = {
  local domain = mylib.rootDomain(config),
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
        'authorize.%s' % domain,
      ],
    },
    virtualHost: {
      domains: [
        'authorize.%s' % domain,
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
