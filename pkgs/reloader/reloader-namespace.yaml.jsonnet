local lib = import '../../lib/lib.jsonnet';

local Namespace(config, name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    annotations: {
      'linkerd.io/inject': if lib.getElse(config, 'pkgs.linkerd.enabled', false) then 'enabled' else 'disabled',
    },
    name: name,
  },
};

function(config, prev, namespace) Namespace(config, namespace)
