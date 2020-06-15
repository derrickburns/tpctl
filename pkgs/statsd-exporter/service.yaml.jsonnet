local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(9102, 9102, 'metrics'), k8s.port(9125, 9125, 'tcp'), k8s.port(9125, 9125, 'udp', 'UDP')],
  },
};

function(config, prev, namespace, pkg) service(common.package(config, prev, namespace, pkg))
