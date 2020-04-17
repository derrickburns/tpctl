local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [ k8s.port(8080, 8080) ],
    selector: {
      app: if lib.isTrue(me, 'sidecar') then 'flux' else 'fluxrecv',
    },
  },
};

function(config, prev, namespace, pkg) service(common.package(config, prev, namespace, pkg))
