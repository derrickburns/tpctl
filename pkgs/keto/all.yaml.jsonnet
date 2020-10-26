local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local containerPort = 4466;

local deployment(me) = flux.deployment(
  me,
  containers={
    image: 'tidepool/keto:latest',
    ports: [{
      containerPort: containerPort
    }],
  },
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, containerPort)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
