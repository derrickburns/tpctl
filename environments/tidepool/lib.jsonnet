local lib = import '../../lib/lib.jsonnet';

{
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
            enabled: true,
            labels: {
              protocol: 'http',
              type: 'external',
              namespace: lib.getElse(env, 'namespace', name),
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
            enabled: true,
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

