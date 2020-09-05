local argo = import '../../lib/argo.jsonnet';
local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'argo', version: lib.getElse(me, 'version', '0.9.8'), repository: 'https://argoproj.github.io/argo-helm' }) {
  spec+: {
    values+: {
      images: {
        tag: 'v2.10.1',
      },
      controller: {
        metricsConfig: {
          enabled: true,
        },
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'prometheus-operator'),
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    argo.defaultSa(me),
    helmrelease(me),
  ]
)
