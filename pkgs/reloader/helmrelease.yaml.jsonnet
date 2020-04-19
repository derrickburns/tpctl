local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: 'v0.0.51', repository: 'https://stakater.github.io/stakater-charts' }) {
  spec+: {
    values+: {
      reloader: {
        serviceAccount: {
          create: false,
          name: me.pkg,
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
