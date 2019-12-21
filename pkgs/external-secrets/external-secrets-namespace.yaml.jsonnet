local lib = import '../../lib/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    labels: {
      'linkerd.io/inject': if lib.getElse(config, 'pkgs.linkerd.enabled', false) then "enabled" else "disabled",
    },
    name: 'external-secrets',
  },
};

function(config, prev) namespace(config)
