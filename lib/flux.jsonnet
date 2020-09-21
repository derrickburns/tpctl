local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

local patchedImage(map, container) = (
  local newImage = lib.getElse(map, container.name + '.image', container.image);
  local oldParts = std.split(container.image, ":"); 
  local newParts = std.split(newImage, ":"); 
  if oldParts[0] == newParts[0] then newImage else container.image
);

{
  // default metadata for flux gitops
  metadata(me, containers):: {
    local this = self,
    local default = lib.getElse(me, 'gitops.default', 'regex:^master-[0-9A-Fa-f]{40}$'),
    metadata+: {
      annotations+:
        { 'fluxcd.io/automated': if lib.getElse(me, 'gitops.enabled', true) then 'true' else 'false' } +
        { ['fluxcd.io/tag.%s' % container.name]: default for container in containers },
    },
  },

  // a patched version of all containers
  patch(old, this, containers):: (
    local matching = k8s.findMatch(old, this);
    local map = { [c.name]: c for c in k8s.containers(matching) };
    local updateContainer(map, container) = container { image: patchedImage(map, container) };
    std.map(function(c) updateContainer(map, c), containers)
  ),

  deployment(me, containers, volumes=[], serviceAccount=false):: { containerPatch:: $.patch} + k8s.deployment(me, containers=containers, volumes=volumes, serviceAccount=serviceAccount) + $.metadata(me, k8s.toContainerList(me,containers))
}
