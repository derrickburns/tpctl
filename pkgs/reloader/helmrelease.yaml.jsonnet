local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: 'v0.0.51', repository: 'https://stakater.github.io/stakater-charts' }) {
  spec+: {
    values+: {
      reloader: {
        serviceAccount: {
          create: false,
          name: 'reloader',
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
