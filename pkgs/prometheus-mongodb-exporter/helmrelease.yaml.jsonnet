local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '2.5.0' }) {
  spec+: {
    values+: {
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
      existingSecret: {
        name: 'mongo',  // XXX confirm
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
