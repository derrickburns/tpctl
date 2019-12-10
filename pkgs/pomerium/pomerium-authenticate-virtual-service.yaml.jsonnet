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
    name: 'authenticate',
    namespace: 'pomerium',
  },
  spec: {
    displayName: 'authenicate',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: 'pomerium',
      },
      sniDomains: [
        'authenticate.%s' % domain,
      ],
    },
    virtualHost: {
      domains: [
        'authenticate.%s' % domain,
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
                name: 'pomerium-authenticate',
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
