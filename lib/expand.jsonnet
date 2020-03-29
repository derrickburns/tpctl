local lib = import 'lib.jsonnet';

// a virtual service that exports the dns name for this package
local virtualServiceDescription(me, config, pkg) = {
  virtualServices: {
    [pkg]: {
      enabled: true,
      labels: {
        type: 'pomerium',
        protocol: 'https',
      },
      dnsNames: [lib.getElse(me, 'dnsName', '%s.%s' % [pkg, config.cluster.metadata.domain])],
    },
  },
};

// add virtual service description for packages that need one
local addVirtualServiceIfNeeded(me, config, name, pkg) = me + (
  if (!std.objectHas(me, 'virtualServices')) && lib.getElse(me, 'export', false)
  then virtualServiceDescription(me, config, pkg)
  else {}
);

local dispatch = {
  tidepool:: import '../pkgs/tidepool/expand.jsonnet',
  pomerium:: import 'pom.jsonnet',
};

local addLocalChanges(me, config, name, pkg) =
  if std.objectHasAll(dispatch, pkg)
  then dispatch[pkg].expand(config, me, name)
  else me;

local purgeDisabled(me, config, name, pkg) = if lib.isEnabled(me) then me else {};

// list of package expander functions to call in order
local packageExpanders = [
  addVirtualServiceIfNeeded,
  addLocalChanges,
  purgeDisabled,
];

// expand all packages in a namespace
local namespaceExpander(config, name, namespace) = (
  local expand(key, pkg) = std.foldl(function(prev, f) f(prev, config, name, key), packageExpanders, pkg);
  std.mapWithKey(expand, namespace)
);

{
  expand(config):: (
    local e(name, namespace) = namespaceExpander(config, name, namespace);
    config { namespaces+: std.mapWithKey(e, config.namespaces) }
  ),
}
