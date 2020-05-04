local lib = import 'lib.jsonnet';

// a virtual service that exports the dns name for this package
local virtualServiceDescription(config, me, namespace, pkg) = {
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
local addVirtualServiceIfNeeded(config, me, namespace, pkg) = me + (
  if (!std.objectHas(me, 'virtualServices')) && lib.getElse(me, 'export', false)
  then virtualServiceDescription(config, me, namespace, pkg)
  else {}
);

local labelVirtualServices(config, me, namespace, pkg) = me +  {
  local update(vsname, vs) = { name: vsname, namespace: namespace } + vs,
  virtualServices+: std.mapWithKey(update, lib.getElse(me, 'virtualServices', {}))
};

local dispatch = {
  tidepool:: import '../pkgs/tidepool/expand.jsonnet',
  pomerium:: import 'pom.jsonnet',
};

local addNamespace(config, me, namespace, pkg) = me { namespace: namespace };

local addLocalChanges(config, me, namespace, pkg) = (
  if std.objectHasAll(dispatch, pkg)
  then dispatch[pkg].expand(config, me, namespace, pkg)
  else me
);

local purgeDisabled(config, me, namespace, pkg) = if lib.isEnabled(me) then me else {};

// list of package expander functions to call in order
local packageExpanders = [
  addNamespace,
  addVirtualServiceIfNeeded,
  labelVirtualServices,
  addLocalChanges,
  labelVirtualServices,
  purgeDisabled,
];

// expand all packages in a namespace
local namespaceExpander(config, namespace, namespaceObj) = (
  local expand(pkg, me) = std.foldl(function(prev, f) f(config, prev, namespace, pkg), packageExpanders, me);
  std.mapWithKey(expand, namespaceObj)
);

{
  expand(config):: (
    local e(namespace, namespaceObj) = namespaceExpander(config, namespace, namespaceObj);
    config { namespaces+: std.mapWithKey(e, config.namespaces) }
  ),
}
