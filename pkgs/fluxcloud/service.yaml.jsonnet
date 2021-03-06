local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(80, 3032)],
  },
};

function(config, prev, namespace, pkg) service(common.package(config, prev, namespace, pkg))
