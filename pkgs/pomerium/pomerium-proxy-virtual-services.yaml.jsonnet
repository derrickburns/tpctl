local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local proxyVirtualService(config, namespace) = {
  local domains = mylib.dnsNames(config),
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'https',
      type: 'pomerium',
    },
    name: 'proxy-https',
    namespace: namespace,
  },
  spec: {
    displayName: 'proxy-https',
    sslConfig: {
      secretRef: {
        name: 'pomerium-tls',
        namespace: namespace,
      },
      sniDomains: domains,
    },
    virtualHost: {
      domains: domains,
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
                namespace: namespace,
              },
            },
          },
          options: {
            headerManipulation: {
              requestHeadersToRemove: ['Origin'],
            },
            upgrades: [
              {
                websocket: {
                  enabled: true,
                },
              },
            ],
          },
        },
      ],
    },
  },
};

local httpVirtualService(config, namespace) = {
  apiVersion: 'gateway.solo.io/v1',
  kind: 'VirtualService',
  metadata: {
    labels: {
      protocol: 'http',
      type: 'pomerium',
    },
    name: 'proxy-http',
    namespace: namespace,
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

function(config, prev, namespace)
  std.manifestYamlStream([httpVirtualService(config, namespace), proxyVirtualService(config, namespace)])
