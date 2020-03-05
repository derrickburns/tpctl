local lib = import 'lib.jsonnet';

local dispatch = {
  tidepool:: import '../pkgs/tidepool/expand.jsonnet',
  pomerium:: import '../pkgs/pomerium/lib.jsonnet',
};

// a virtual service that exports the dns name for this package
local expandExport(config, name, key, pkg) = {
  local dnsName = lib.getElse(pkg, 'dnsName', '%s.%s' % [key, config.cluster.metadata.domain]),

  virtualServices: {
    [key]: {
      enabled: true,
      labels: {
        type: 'pomerium',
        protocol: 'https',
      },
      dnsNames: [dnsName],
    },
  },
};

// expand a package if it requires a virtual service
local expandPackage(config, name, key, pkg) =
  pkg +
  (
    if (!std.objectHas(pkg, 'virtualServices')) && lib.getElse(pkg, 'export', false)
    then expandExport(config, name, key, pkg)
    else {}
  );

// expand a namespace
local expandNamespace(config, name, namespace) = (
  local expand(key, pkg) = (
    if std.objectHasAll(dispatch, key)
    then dispatch[key].expand(config, pkg, name)
    else if (!std.objectHas(pkg, 'virtualServices')) && lib.getElse(pkg, 'export', false)
    then expandPackage(config, name, key, pkg)
    else pkg
   );

  std.mapWithKey(expand, namespace)
);

{
  expandConfig(config):: (
    local expand(name, namespace) = expandNamespace(config, name, namespace);
    config { namespaces+: std.mapWithKey(expand, config.namespaces) }
  ),
}
