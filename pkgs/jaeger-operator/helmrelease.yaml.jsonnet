local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: lib.getElse(me, 'version', '2.17.0'), repository: 'https://jaegertracing.github.io/helm-charts' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'prometheus-operator'),
      },
      rbac: {
        clusterRole: true,
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
