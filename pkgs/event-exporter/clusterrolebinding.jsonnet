local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrolebinding(me) = k8s.clusterrolebinding(me) {
  roleRef+: {
    name: 'view',
  }
};

function(config, prev, namespace, pkg) clusterrolebinding(common.package(config, prev, namespace, pkg))
