local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local grafanapvc(me) = k8s.pvc(me, '30Gi') {
  metadata: {
    name: 'grafana',
    namespace: me.namespace,
    labels: {
      app: 'grafana',
    },
  },
  spec+: {
    storageClassName: 'monitoring-expanding',
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    grafanapvc(me),
  ]
)
