local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local persistentvolumeclaim(me) = k8s.pvc(me, lib.getElse(me, 'capacity', '1Gi')) {
  spec+: {
    storageClassName: 'gp2-expanding',
  },
};

function(config, prev, namespace, pkg) persistentvolumeclaim(common.package(config, prev, namespace, pkg))
