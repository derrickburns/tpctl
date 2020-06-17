local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local containerPort = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/kafka-database-worker:latest',
    env: [
      k8s.envSecret('TIMESCALEDB_PASSWORD', 'timescaledb-single-passwords', 'postgres'),
    ],
    ports: [{
      containerPort: containerPort,
    }],
  },
  spec+: {
    template+: linkerd.metadata(me, true),
  },
};

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
    gloo.kubeupstream(me),
  ]
)
