local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local standalone_ha = importstr 'standalone-ha.xml';
local configmap(me) = k8s.configmap(me) + {
  metadata+: {
    name: 'standalone-ha',
  },
  data: {
    'standalone-ha.xml': standalone_ha
  }
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
  ]
)
