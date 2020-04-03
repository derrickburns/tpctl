local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [ k8s.port(443, 8443) ],
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
