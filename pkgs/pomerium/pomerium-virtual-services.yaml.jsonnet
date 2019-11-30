local lib = import '../../lib/lib.jsonnet';

local dnsNames(config) = (
  local pkgs = config.pkgs;
  [
    pkgs[x].sso.dnsName
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso.dnsName', '') != ''
  ]
);

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
      sniDomains: dnsNames(config),
    },
    virtualHost: {
      domains: dnsNames(config),
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
