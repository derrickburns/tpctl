local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

{
  shadowNames(names):: std.map(function(x) '%s-shadow' % x, names),

  tpFor(config, name):: lib.getElse(config, 'namespaces.' + name + '.tidepool', null),

  isShadow(env):: lib.isTrue(env, 'shadow.enabled') && (lib.getElse(env, 'shadow.sender', null) != null),

  hasShadow(env):: lib.isTrue(env, 'shadow.enabled') && (lib.getElse(env, 'shadow.receiver', null) != null),

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

  jwks(config, name):: {
    local me = $.tpFor(config, name),
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
                name: '%s-jwks-80' % me.namespace,
                namespace: me.namespace,
              },
              url: 'http://jwks.%s/jwks.json' % me.namespace,
            },
          },
        },
      },
    },
  },

  expand(config, pkg, name):: (
    local dnsNames = lib.getElse(pkg, 'dnsNames', []);
    local result = pkg {
      virtualServices: {
        http: {
          dnsNames: dnsNames,
          enabled: !$.isShadow($.tpFor(config, name)),
          labels: {
            protocol: 'http',
            type: 'external',
            namespace: name,
          },
          virtualHostOptions: {
            stats: {
              virtualClusters: lib.getElse(pkg, 'virtualClusters', []),
            },
          },
          redirect: true,
        },
        https: {
          dnsNames: dnsNames,
          enabled: !$.isShadow($.tpFor(config, name)),
          timeout: lib.getElse(pkg, 'maxTimeout', '120s'),
          hsts: {
            enabled: true,
          },
          cors: {
            enabled: true,
          },
          virtualHostOptions: {
            stats: {
              virtualClusters: lib.getElse(pkg, 'virtualClusters', []),
            },
          } + $.jwks(config, name),
          routeOptions: if $.hasShadow($.tpFor(config, name)) then {
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
            namespace: name,
          },
        },
      },
    };
    result
  ),
}
