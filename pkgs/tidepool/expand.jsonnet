local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

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

  expand(config, me, namespace, pkg):: (
    local dnsNames = lib.getElse(me, 'dnsNames', []);
    local result = me {
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
          cors: {
            enabled: true,
          },
          virtualHostOptions: {
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
    };
    result
  ),
}
