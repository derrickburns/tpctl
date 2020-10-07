local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local port = 8080;

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      k8s.port(port, port),
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    gloo.kubeupstream(me),
  ]
)
