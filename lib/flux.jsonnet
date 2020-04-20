local lib = import 'lib.jsonnet';
local k8s = import 'k8s.jsonnet';

{
  metadata(automated=true, pattern='glob:master-*'):: {
    local this = self,
    metadata+: {
      annotations+: {
                      'fluxcd.io/automated': if automated then 'true' else 'false',
                    } +
                    {
                      ['fluxcd.io/tag.%s' % container.name]: pattern
                      for container in
                        lib.getElse(this, 'spec.template.spec.containers', [])
                    },
    },
  },

  containers(manifest)::
    if manifest.kind == 'Deployment' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Daemonset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Statefulset' then manifest.spec.template.spec.containers
    else if manifest.kind == 'Pod' then manifest.spec.containers
    else [],

  patch(old, this, containers):: (
    local matching = k8s.findMatch(old, this);
    local map = { [c.name]: c for c in $.containers(matching) };
    local updateContainer(map, container) = lib.getElse(map, container.name + '.image', container.image);
    std.map(function(c) updateContainer(map, c), containers)
  ),
}
