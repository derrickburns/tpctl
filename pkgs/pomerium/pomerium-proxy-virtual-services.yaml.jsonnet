local lib = import '../../lib/lib.jsonnet';

local mylib = import 'lib.jsonnet';

// Redirect forward auth requests to the pomerium server.
// We use the header 'x-tidepool-extauth-request' to identify authorization requests.
local forwardauthRedirectVirtualServices(config) = (
  local pkgs = config.pkgs;
  [
    {
      local pkg = pkgs[x],
      local downstreamDNS = mylib.dnsNameForName(config, x),

      apiVersion: 'gateway.solo.io/v1',
      kind: 'VirtualService',
      metadata: {
        labels: {
          protocol: 'http',
          type: 'internal',
        },
        name: '%s-rewrite-http' % x,
        namespace: 'pomerium',
      },
      spec: {
        displayName: '%s-redirect-https' % x,
        virtualHost: {
          domains: [downstreamDNS],
          routes: [
            {
              matchers: [
                {
	          headers: [ {
                    name: "x-tidepool-extauth-request",
                  } ],
                  prefix: '/',
                },
              ],
              routeAction: {
                single: {
                  upstream: {
                    name: 'pomerium-proxy',
                    namespace: 'pomerium',
                  },
                }
              },
              options: {
                hostRewrite: 'forwardauth.%s' % mylib.rootDomain(config),
                prefixRewrite: '/verify?uri=https://%s/' % downstreamDNS,
              },
            },
          ],
        },
      },
    }
    for x in std.objectFields(pkgs)
    if lib.getElse(pkgs[x], 'sso', {}) != {} && lib.getElse(pkgs[x], 'enabled', false)
  ]
);

// Require authorization via the external authorization service.
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
                 headers: [ {
                     name: 'x-tidepool-extauth-request',
                     invertMatch: true, 
                   } ],
	         prefix: "/",
                }
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
    if lib.getElse(pkgs[x], 'sso', {}) != {} && lib.getElse(pkgs[x], 'enabled', false)
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
            headerManipulation: {
              requestHeadersToRemove: [ "Origin" ],
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
  std.manifestYamlStream([httpVirtualService(config), proxyVirtualService(config)]
  + (if lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false)
     then forwardauthVirtualServices(config) + forwardauthRedirectVirtualServices(config) 
     else []
    ))
