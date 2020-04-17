local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      k8s.port( 55678, 55678, 'opencensus'),
      k8s.port( 9411, 9411, 'zipkin'),
      k8s.port( 8888, 8888, 'metrics'),
    ],
  },
};

function(config, prev, namespace, pkg) service(common.package(config, prev, namespace, pkg))
