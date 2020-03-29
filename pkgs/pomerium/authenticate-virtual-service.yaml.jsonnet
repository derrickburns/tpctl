local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local mylib = import '../../lib/pom.jsonnet';

local virtualService(config, namespace) = k8s.k('gateway.solo.io/v1', 'VirtualService') + k8s.metadata('authenticate', namespace) {
  local domain = mylib.rootDomain(config),
  metadata+: {
    labels: {
      protocol: 'https',
      type: 'pomerium',
    },
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
