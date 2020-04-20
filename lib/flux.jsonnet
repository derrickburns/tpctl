local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  // default metadata for flux gitops
  metadata():: {
    local this = self,
    local default = lib.getElse(this, 'gitops.default', 'regex:master-[0-9A-Za-z]{40}'),
    metadata+: {
      annotations+:
        { 'fluxcd.io/automated': if lib.getElse(this, 'gitops.enabled', true) then 'true' else 'false' } +
        { ['fluxcd.io/tag.%s' % container.name]: default for container in $.containers(this) },
    },
  },

  // all containers in a K8s manifest
  containers(manifest)::
    if manifest.kind == 'Deployment' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Daemonset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Statefulset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Pod' then manifest.spec.containers
    else [],

  // a patched version of all containers
  patch(old, this, containers):: (
    local matching = k8s.findMatch(old, this);
    local map = { [c.name]: c for c in $.containers(matching) };
    local updateContainer(map, container) =
      container { image: lib.getElse(map, container.name + '.image', container.image) };
    std.map(function(c) updateContainer(map, c), containers)
  ),

  deployment(me):: k8s.deployment(me) + $.metadata() {
    local this = self,
    spec+: {
      template+: {
        spec+: {
          containers: $.patch(me.prev, this, this._containers)
        },
      },
    },
  }
}
