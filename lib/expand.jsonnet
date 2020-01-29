local lib = import 'lib.jsonnet';

local pom = import '../pkgs/pomerium/lib.jsonnet';

{
  expandConfig(config)::
    config
    + (if std.objectHas(config, 'environments')
       then { environments: $.expandEnvironments(config) }
       else {})
    + (if std.objectHas(config, 'pkgs')
       then { pkgs: $.expandPackages(config) }
       else {}),

  expandEnvironments(config):: (
    local expandEnvironment = function(name, env) $.expandConfigEnvironment(config, name, env);
    std.mapWithKey(expandEnvironment, config.environments)
  ),

  expandPackages(config):: (
    local expandPackage = function(name, pkg) $.expandConfigPackage(config, name, pkg);
    std.mapWithKey(expandPackage, config.pkgs)
  ),

  expandConfigPackage(config, name, pkg):: (
    if name == 'pomerium'
    then pom.expandPomerium(config)
    else (
      local dnsName = lib.getElse(pkg, 'dnsName', '%s.%s' % [name, config.cluster.metadata.domain]);
      pkg +
      (
        if (!std.objectHas(pkg, 'virtualServices')) && lib.getElse(pkg, 'export', false)
        then {
          virtualServices: {
            [name]: {
              enabled: true,
              labels: {
                type: 'external',
                protocol: 'https',
              },
              dnsNames: [dnsName],
            },
          },
        }
        else {}
      )
    )
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
            redirect: true,
          },
          'httpInternal': {
            dnsNames: dnsNames,
            enabled: false,
            labels: {
              protocol: 'http',
              type: 'internal',
              namespace: lib.getElse(env, 'namespace', name),
            },
          },
          https: {
            dnsNames: dnsNames,
            enabled: true,
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
            options: {
              timeout: lib.getElse(env, 'tidepool.maxTimeout', '120s'),
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
