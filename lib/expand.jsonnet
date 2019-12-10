local lib = import 'lib.jsonnet';

local pom = import 'pkgs/pomerium/lib.jsonnet';

{
  expandConfig(config)::
    config
    + (if std.objectHas(config, 'environments')
      then { environments: $.expandEnvironments(config.environments) }
      else {})
    + (if lib.getElse(config, 'pkgs.pomerium.enabled', false)
       then { pkgs+: { pomerium: pom.expandPomerium(config) } }
       else {}),

  expandEnvironments(envs):: std.mapWithKey($.expandEnvironment, envs),

  expandEnvironment(name, env):: (
    local dnsNames = lib.getElse(env, 'tidepool.dnsNames', []);
    env + $.expandEnvironmentVirtualServices(dnsNames, name)
  ),

  expandEnvironmentVirtualServices(dnsNames, namespace):: {
    tidepool+: {
      virtualServices: {
        http: {
          dnsNames: dnsNames,
          enabled: true,
          labels: {
            protocol: 'http',
            type: 'external',
          },
          redirectAction: true,
        },
        'http-internal': {
          delegateAction: 'tidepool-routes',
          dnsNames: [
            'internal.%s' % namespace,
          ],
          enabled: true,
          labels: {
            protocol: 'http',
            type: 'internal',
          },
        },
        https: {
          delegateAction: 'tidepool-routes',
          dnsNames: dnsNames,
          enabled: true,
          labels: {
            protocol: 'https',
            type: 'external',
          },
        },
      },
    },
  },
}
