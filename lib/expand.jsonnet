local lib = import 'lib.jsonnet';

local pom = import '../pkgs/pomerium/lib.jsonnet';

local tp = import '../environments/tidepool/lib.jsonnet';

{
  expandConfig(config)::
    config
    + (if std.objectHas(config, 'environments')
       then { environments: tp.expandEnvironments(config) }
       else {})
    + (if std.objectHas(config, 'pkgs')
       then { pkgs: $.expandPackages(config) }
       else {}),

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
                type: 'pomerium',
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
}
