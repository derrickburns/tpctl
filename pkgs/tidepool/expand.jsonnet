local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local accessLogging = {
    accessLoggingService: {
      accessLog: [
        {
          fileSink: {
            jsonFormat: {
              authority: '%REQ(:authority)%',
              authorization: '%REQ(authorization)%',
              content: '%REQ(content-type)%',
              duration: '%DURATION%',
              forwardedFor: '%REQ(X-FORWARDED-FOR)%',
              method: '%REQ(:method)%',
              path: '%REQ(:path)%',
              remoteAddress: '%DOWNSTREAM_REMOTE_ADDRESS_WITHOUT_PORT%',
              request: '%REQ(x-tidepool-trace-request)%',
              response: '%RESPONSE_CODE%',
              scheme: '%REQ(:scheme)%',
              bytesReceived: '%BYTES_RECEIVED%',
              responseCodeDetail: '%RESPONSE_CODE_DETAILS%',
              requestDuration: '%REQUEST_DURATION%',
              responseFlags: '%RESPONSE_FLAGS%',
              session: '%REQ(x-tidepool-trace-session)%',
              startTime: '%START_TIME%',
              token: '%REQ(x-tidepool-session-token)%',
              upstream: '%UPSTREAM_CLUSTER%',
              clientName: '%REQ(x-tidepool-client-name)%',
              userAgent: '%REQ(user-agent)%',
              referer: '%REQ(referer)%',
            },
            path: '/dev/stdout',
          },
        },
      ],
    },
  };

{
  shadowNames(names):: std.map(function(x) '%s-shadow' % x, names),

  tpFor(config, name):: lib.getElse(config, 'namespaces.' + name + '.tidepool', null),

  isShadow(me):: lib.isTrue(me, 'shadow.enabled') && lib.nonNull(me, 'shadow.sender'),

  hasShadow(me):: lib.isTrue(me, 'shadow.enabled') && lib.nonNull(me, 'shadow.receiver'),

  genDnsNames(config, name):: (
    local me = $.tpFor(config, name);
    local sender = lib.getElse(me, 'shadow.sender', null);
    if $.isShadow(me)
    then $.shadowNames(lib.getElse($.tpFor(config, sender), 'dnsNames', []))
    else lib.getElse(me, 'dnsNames', [])
  ),

  internalGatewayUpstream: {
    name: 'gloo-system-internal-gateway-proxy-80',
    namespace: 'gloo-system',  // XXX
  },

  jwks(config, namespace):: {
    local me = $.tpFor(config, namespace),
    jwt: {
      providers: {
        'tidepool-provider': {
          issuer: me.gateway.apiHost,
          audiences: [me.gateway.apiHost],
          tokenSource: {
            headers: [{
              header: 'x-tidepool-session-token',
              prefix: '',
            }],
          },
          keepToken: true,
          claimToHeaders: [{
            claim: 'sub',
            header: 'x-tidepool-userid',
            append: false,
          }, {
            claim: 'svr',
            header: 'x-tidepool-isServer',
            append: false,
          }],
          jwks: {
            remote: {
              upstream_ref: {
                name: 'jwks',
                namespace: namespace,
              },
              url: 'http://jwks.%s/jwks.json' % namespace,
            },
          },
        },
      },
    },
  },

  expand(config, me, namespace, pkg)::
    me
    + $.withVirtualServices(config, me, namespace, pkg)
    + $.withGateways(config, me, namespace, pkg),

  withGateways(config, me, namespace, pkg):: (
    local update(name, x) = { name: name, namespace: namespace } + x;
    { gateways+: std.mapWithKey(update, $.gateways) }
  ),

  gateways:: {
    'gateway-proxy'+: {
      enabled: true,
      accessLogging: accessLogging,
      options+: {
        healthCheck: true,
        proxyProtocol: true,
        tracing: true,
      },
      proxies: [
        'gateway-proxy',
      ],
      selector: {
        protocol: 'http',
        type: 'external',
      },
    },
    'gateway-proxy-ssl'+: {
      enabled: true,
      accessLogging: accessLogging,
      options+: {
        healthCheck: true,
        proxyProtocol: true,
        ssl: true,
        tracing: true,
      },
      proxies: [
        'gateway-proxy',
      ],
      selector: {
        protocol: 'https',
        type: 'external',
      },
    },
    'internal-gateway-proxy'+: {
      enabled: true,
      accessLogging: accessLogging,
      options+: {
        tracing: true,
      },
      proxies: [
        'internal-gateway-proxy',
      ],
      selector: {
        protocol: 'http',
        type: 'internal',
      },
    },
    'internal-gateway-proxy-ssl'+: {
      enabled: true,
      accessLogging: accessLogging,
      options+: {
        ssl: true,
        tracing: true,
      },
      proxies: [
        'internal-gateway-proxy',
      ],
      selector: {
        protocol: 'https',
        type: 'internal',
      },
    },
  },

  cors: {
    allowCredentials: true,
    allowHeaders: [
      'authorization',
      'content-type',
      'x-tidepool-session-token',
      'x-tidepool-trace-request',
      'x-tidepool-trace-session',
    ],
    allowMethods: [
      'GET',
      'POST',
      'PUT',
      'PATCH',
      'DELETE',
      'OPTIONS',
    ],
    allowOriginRegex: [
      '.*',
    ],
    exposeHeaders: [
      'x-tidepool-session-token',
      'x-tidepool-trace-request',
      'x-tidepool-trace-session',
    ],
    maxAge: '600s',
  },

  withVirtualServices(config, me, namespace, pkg):: (
    local dnsNames = lib.getElse(me, 'dnsNames', []);
    {
      virtualServices: {
        http: {
          dnsNames: dnsNames,
          enabled: !$.isShadow(me),
          labels: {
            protocol: 'http',
            type: 'external',
            namespace: namespace,
          },
          virtualHostOptions: {
            stats: {
              virtualClusters: lib.getElse(me, 'virtualClusters', []),
            },
          },
          redirect: true,
        },
        https: {
          dnsNames: dnsNames,
          enabled: !$.isShadow(me),
          timeout: lib.getElse(me, 'maxTimeout', '120s'),
          hsts: {
            enabled: true,
          },
          virtualHostOptions: {
            cors: $.cors,
            stats: {
              virtualClusters: lib.getElse(me, 'virtualClusters', []),
            },
          } + $.jwks(config, namespace),
          routeOptions: if $.hasShadow(me) then {
            shadowing: {
              upstream: $.internalGatewayUpstream,
              percentage: 100.0,
            },
          } else {},
          routeAction: {
            single: {
              upstream: $.internalGatewayUpstream,
            },
          },
          labels: {
            protocol: 'https',
            type: 'external',
            namespace: namespace,
          },
        },
      },
    }
  ),
}
