local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

local forwardauthVirtualServices(config) = (
  local pkgs = config.pkgs;
  [
    {
      local pkg = pkgs[x],
      local downstreamDNS = mylib.dnsNameForName(config, x),
      local upstreamPort = lib.getElse(pkg, 'sso.port', 8080),
      local upstreamName = lib.getElse(pkg, 'sso.serviceName', x),
      local upstreamNamespace = lib.getElse(pkg, 'namespace', x),

      apiVersion: 'gateway.solo.io/v1',
      kind: 'VirtualService',
      metadata: {
        labels: {
          protocol: 'https',
          type: 'external',
        },
        name: '%s-https' % x,
        namespace: 'pomerium',
      },
      spec: {
        displayName: '%s-https' % x,
        sslConfig: {
          secretRef: {
            name: 'pomerium-tls',
            namespace: 'pomerium',
          },
          sniDomains: [downstreamDNS],
        },
        virtualHost: {
          domains: [downstreamDNS],
          options: {
            extauth: {
              customAuth: { }
            },
          },
          routes: [
            {
              matchers: [
                {
                  prefix: '/',
                },
              ],
              routeAction: {
                single: {
                  kube: {
                    ref: {
                      name: upstreamName,
                      namespace: upstreamNamespace,
                    },
                    port: upstreamPort,
                  },
                },
              },
              options: {
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
    }
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso', {}) != {}
  ]
);


local proxyVirtualService(config) = {
  local domains =
    if lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false)
    then ['forwardauth.%s' % mylib.rootDomain(config)]
    else mylib.dnsNames(config),
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
                namespace: 'pomerium',
              },
            },
          },
          options: {
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

function(config, prev) 
  std.manifestYamlStream([httpVirtualService(config)]
  + (if lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false)
     then forwardauthVirtualServices(config)
     else [proxyVirtualService(config)]))
