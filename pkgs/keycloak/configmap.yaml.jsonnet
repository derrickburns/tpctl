local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local standalone_ha = importstr 'standalone-ha.xml';
local jmx_exporter = importstr 'jmx_exporter.yaml.raw';

local configmap(me) = k8s.configmap(me) + {
  metadata+: {
    name: 'custom-configuration',
  },
  data: {
    'standalone-ha.xml': standalone_ha,
    'jmx_exporter.yaml': jmx_exporter,
  }
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
  ]
)
