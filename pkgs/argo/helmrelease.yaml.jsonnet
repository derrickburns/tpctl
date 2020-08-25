local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'argo', version: lib.getElse(me, 'version', '0.9.8'), repository: 'https://argoproj.github.io/argo-helm' }) {
  spec+: {
    values+: {
      controller: {
        serviceMonitor: {
          enabled: true,
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
