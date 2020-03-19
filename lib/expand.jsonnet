local lib = import 'lib.jsonnet';

// a virtual service that exports the dns name for this package
local virtualServiceDescription(config, name, pkgName, pkg) = {
  local dnsName = lib.getElse(pkg, 'dnsName', '%s.%s' % [pkgName, config.cluster.metadata.domain]),

  virtualServices: {
    [pkgName]: {
      enabled: true,
      labels: {
        type: 'pomerium',
        protocol: 'https',
      },
      dnsNames: [dnsName],
    },
  },
};

// add virtual service description for packages that need one
local addVirtualServiceIfNeeded(config, name, pkgName, pkg) = pkg + (
  if (!std.objectHas(pkg, 'virtualServices')) && lib.getElse(pkg, 'export', false)
  then virtualServiceDescription(config, name, pkgName, pkg)
  else {}
);

local dispatch = {
  tidepool:: import '../pkgs/tidepool/expand.jsonnet',
  pomerium:: import '../pkgs/pomerium/lib.jsonnet',
};

local addLocalChanges(config, name, pkgName, pkg) =
  if std.objectHasAll(dispatch, pkgName) then dispatch[pkgName].expand(config, pkg, name) else pkg;

// list of package expander functions to call in order
local packageExpanders = [
  addVirtualServiceIfNeeded,
  addLocalChanges
];

// expand all packages in a namespace
local namespaceExpander(config, name, namespace) = (
  local expand(key, pkg) = std.foldl(function(prev, f) f(config, name, key, prev), packageExpanders, pkg);
  std.mapWithKey(expand, namespace)
);

{
  expand(config):: (
    local e(name, namespace) = namespaceExpander(config, name, namespace);
    config { namespaces+: std.mapWithKey(e, config.namespaces) }
  ),
}
