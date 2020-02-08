local lib = import '../../lib/lib.jsonnet';

{
  shadowNames(names):: std.map( function (x) "%s-shadow" % x, names),

  tpFor(config, name):: lib.getElse(config, 'environments.' + name + '.tidepool', null),

  isShadow(env):: lib.isTrue(env, 'shadow.enabled') && (lib.getElse(env, 'shadow.sender', null) != null),

  genDnsNames(config, name):: (
    local me = $.tpFor(config, name);
    local sender = lib.getElse(me, 'shadow.sender', null);
    if $.isShadow(me)
    then $.shadowNames(lib.getElse($.tpFor(config, sender), 'dnsNames', []))
    else lib.getElse(me, 'dnsNames', [])
  ),

  expandEnvironments(config):: (
    local expandEnvironment = function(name, env) $.expandConfigEnvironment(config, name, env);
    std.mapWithKey(expandEnvironment, config.environments)
  ),

  expandConfigEnvironment(config, name, env):: (
    local dnsNames = lib.getElse(env, 'tidepool.dnsNames', []);
    env {
      tidepool+: {
        virtualServices: {
          http: {
            dnsNames: dnsNames,
            enabled: if $.isShadow($.tpFor(config, name)) then false else true,
            labels: {
              protocol: 'http',
              type: 'external',
              namespace: name,
            },
            options: {
              stats: {
                virtualClusters: lib.getElse(env, 'tidepool.virtualClusters', []),
              },
            },
            redirect: true,
          },
          https: {
            dnsNames: dnsNames,
            enabled: if $.isShadow($.tpFor(config, name)) then false else true,
            timeout: lib.getElse(env, 'tidepool.maxTimeout', '120s'),
            hsts: {
              enabled: true,
            },
            cors: {
              enabled: true,
            },
            options: {
              stats: {
                virtualClusters: lib.getElse(env, 'tidepool.virtualClusters', []),
              },
            },
            routeAction: {
              single: {
                kube: {
                  ref: {
                    name: 'internal-gateway-proxy',
                    namespace: 'gloo-system',
                  },
                  port: 80,
                },
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

