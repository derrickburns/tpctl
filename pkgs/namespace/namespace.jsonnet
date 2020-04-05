local linkerd = import '../../lib/linkerd.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local Namespace(config, me) = (
  local meshed = lib.isTrue(me, 'meshed');
  local discoverable = lib.isTrue(me, 'discoverable');
  local goldilocks = lib.isTrue(me, 'goldilocks');

  if lib.getElse(me, 'create', 'true') == 'true'
  then
    {
      apiVersion: 'v1',
      kind: 'Namespace',
      metadata: {
        name: me.namespace,
        annotations:
          lib.getElse(me, 'annotations', {})
          + (if meshed then linkerd.annotations(config) else {}),
        labels:
          lib.getElse(me, 'labels', {})
          + { 'discovery.solo.io/function_discovery': if discoverable then 'enabled' else 'disabled' }
          + { 'goldilocks.fairwinds.com/enabled': if goldilocks then 'true' else 'false' },
      },
    }
  else {}
);

function(config, prev, namespace, pkg) Namespace(config, lib.package(config, namespace, pkg))
