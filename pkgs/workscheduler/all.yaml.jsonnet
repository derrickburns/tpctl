local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local grpcPort = 5051;
local prometheusPort = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/workscheduler:latest',
    env: [
      k8s.envVar('WORK_SCHEDULER_PORT', grpcPort),
      k8s.envVar('PROMETHEUS_SERVER_PORT', prometheusPort),
      k8s.envVar('KAFKA_BROKERS', lib.get(me, 'kafka-brokers')),
      k8s.envVar('KAFKA_TOPIC_PREFIX', lib.get(me, 'kafka-topic-prefix')),
      k8s.envVar('KAFKA_TOPIC', lib.get(me, 'kafka-topic')),
      k8s.envVar('KAFKA_CONSUMER_GROUP', lib.getElse(me, 'kafka-consumer-group', std.join('-', [me.namespace, me.pkg]))),
      k8s.envVar('WORK_TIMEOUT', lib.getElse(me, 'work-timeout', '30s')),
    ],
    imagePullPolicy: 'Always',
    ports: [
      { containerPort: grpcPort },
      { containerPort: prometheusPort }
    ],
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
        k8s.port(grpcPort, grpcPort),
        k8s.port(prometheusPort, prometheusPort),
    ],
  },
};


function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
    service(me)
  ]
)
