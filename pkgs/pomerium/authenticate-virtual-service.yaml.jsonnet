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
    name: 'authenticate',
    namespace: namespace,
  },
  spec: {
    displayName: 'authenicate',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: namespace,
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
                namespace: namespace,
              },
            },
          },
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) virtualService(config, namespace)
