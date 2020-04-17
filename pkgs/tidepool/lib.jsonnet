local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';

{
  shadowNames(names):: std.map(function(x) '%s-shadow' % x, names),

  tpFor(config, name):: (
    assert lib.getElse(config.namespaces, name + '.tidepool', null) != null : std.manifestJson({ c: config, n: name });
    lib.getElse(config.namespaces, name + '.tidepool', null)
  ),

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

  expandEnvironment(config, name, env):: (
    local dnsNames = lib.getElse(env, 'tidepool.dnsNames', []);
    env {
      tidepool+: {
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
                virtualClusters: lib.getElse(env, 'tidepool.virtualClusters', []),
              },
            },
            redirect: true,
          },
          https: {
            dnsNames: dnsNames,
            enabled: !$.isShadow($.tpFor(config, name)),
            timeout: lib.getElse(env, 'tidepool.maxTimeout', '120s'),
            hsts: {
              enabled: true,
            },
            cors: {
              enabled: true,
            },
            virtualHostOptions: {
              stats: {
                virtualClusters: lib.getElse(env, 'tidepool.virtualClusters', []),
              },
            },
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
              namespace: lib.getElse(env, 'namespace', name),
            },
          },
        },
      },
    }
  ),
}
