local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'cert-manager', version: 'v0.14.1', repository: 'https://charts.jetstack.io' }) {
  spec+: {
    values+: {
      serviceAccount: {
        create: false,
        name: 'cert-manager',
      },
      prometheus: {
        servicemonitor: {
          enabled: global.isEnabled(me.config, 'prometheus-operator'),
        },
      },
      securityContext: {
        enabled: true,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
