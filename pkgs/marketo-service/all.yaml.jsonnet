local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';

local port = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/marketo-service:master-latest',
    env: [
      k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
      k8s.envVar('KAFKA_TOPIC', lib.getElse(me, 'kafka-topic', 'marketo' )),
    ],
    imagePullPolicy: 'Always',
    ports: [{
      containerPort: port
    }],
  },
};

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
    deployment(me),
    service(me),
    gloo.kubeupstream(me),
  ]
)