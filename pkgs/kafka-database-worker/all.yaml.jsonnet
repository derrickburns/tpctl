local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local containerPort = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/kafka-database-worker:latest',
    env: [
      k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
      k8s.envVar('KAFKA_TOPIC', lib.getElse(me, 'kafka-topic', me.namespace + '.' + 'data.data.deviceData' + ',' + me.namespace + '.' + 'user.user.users')),
      k8s.envVar('TIMESCALEDB_HOST', lib.getElse(me, 'postgres-host', 'timescaledb-single.timescaledb.svc.cluster.local')),
      k8s.envVar('TIMESCALEDB_USER', lib.getElse(me, 'postgres-user', 'postgres')),
      k8s.envVar('TIMESCALEDB_DBNAME', lib.getElse(me, 'postgres-dbname', 'postgres')),
      k8s.envSecret('TIMESCALEDB_PASSWORD', 'timescaledb-single-passwords', 'postgres'),
    ],
    ports: [{
      containerPort: containerPort,
    }],
    resources: {
      limits: {
        cpu: '1000m',
        memory: '800Mi',
      },
      requests: {
        cpu: '100m',
        memory: '100Mi',
      },
    },
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
