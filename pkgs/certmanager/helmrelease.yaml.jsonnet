local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) =
  k8s.helmrelease(me, { name: 'cert-manager', version: 'v0.14.1', repository: 'https://charts.jetstack.io' }) {
    spec+: {
      values: {
        serviceAccount: {
          create: false,
        },
      },
    },
  };

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
