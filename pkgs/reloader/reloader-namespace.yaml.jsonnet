local lib = import '../../lib/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    annotations: {
      'linkerd.io/inject': if lib.getElse(config, 'pkgs.linkerd.enabled', false) then "enabled" else "disabled",
    },
    name: 'reloader',
  },
};

function(config, prev) namespace(config)
