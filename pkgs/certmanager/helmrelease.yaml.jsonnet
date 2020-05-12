local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = lib.E(me, k8s.helmrelease(me, { name: 'cert-manager', version: 'v0.14.1', repository: 'https://charts.jetstack.io' }) {
  spec+: {
    values+: {
      serviceAccount: {
        create: false,
        name: me.pkg,
      },
    },
  },
});

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
