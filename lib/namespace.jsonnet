local linkerd = import '../pkgs/linkerd/lib.jsonnet';
local lib = import 'lib.jsonnet';

local Namespace(config, name) = (
  local nsConfig = lib.getElse(config, 'namespaces.' + name + '.config', {});
  local meshed = lib.isTrue(nsConfig, 'meshed');
  local discoverable = lib.isTrue(nsConfig, 'discoverable');
  local goldilocks = lib.isTrue(nsConfig, 'goldilocks');

  if lib.getElse(nsConfig, 'create', 'true') == 'true'
  then
    {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: name,
        annotations:
          lib.getElse(nsConfig, 'annotations', {})
          + (if meshed then linkerd.annotations(config) else {}),
        labels:
          lib.getElse(nsConfig, 'labels', {})
          + { 'discovery.solo.io/function_discovery': if discoverable then 'enabled' else 'disabled' }
          + { 'goldilocks.fairwinds.com/enabled': if goldilocks then 'true' else 'false' },
      },
    }
  else {}
);

function(config, namespace) Namespace(config, namespace)
