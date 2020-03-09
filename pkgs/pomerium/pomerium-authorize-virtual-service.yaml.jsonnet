local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local virtualService(config, namespace) = {
  local domain = mylib.rootDomain(config),
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'pomerium',
    },
    name: 'authorize',
    namespace: namespace,
  },
  spec: {
    displayName: 'authorize',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: namespace,
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
                namespace: namespace,
              },
            },
          },
        },
      ],
    },
  },
};

function(config, prev, namespace) virtualService(config, namespace)
