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
            },
            redirect: true,
          },
          'httpInternal': {
            dnsNames: [
              'internal.%s' % name,
            ],
            enabled: true,
            labels: {
              protocol: 'http',
              type: 'internal',
            },
          },
          https: {
            dnsNames: dnsNames,
            enabled: true,
            labels: {
              protocol: 'https',
              type: 'external',
            },
          },
        },
      },
    }
  ),
}
