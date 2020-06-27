local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local containerPort = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/kafka-database-import:latest',
    env: [
      k8s.envSecret('TIDEPOOL_STORE_SCHEME', 'mongo', 'Scheme'),
      k8s.envSecret('TIDEPOOL_STORE_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('TIDEPOOL_STORE_PASSWORD', 'mongo', 'Password'),
      k8s.envSecret('TIDEPOOL_STORE_ADDRESSES', 'mongo', 'Addresses'),
      k8s.envSecret('TIDEPOOL_STORE_OPT_PARAMS', 'mongo', 'OptParams'),
      k8s.envSecret('TIDEPOOL_STORE_TLS', 'mongo', 'Tls'),
      k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
      k8s.envVar('KAFKA_TOPIC', me.namespace + '-' + lib.getElse(me, 'kafka-topic', 'data')),
      k8s.envVar('TIMESCALEDB_HOST', lib.getElse(me, 'postgres-host', 'timescaledb-single.timescaledb.svc.cluster.local')),
      k8s.envVar('TIMESCALEDB_USER', lib.getElse(me, 'postgres-user', 'postgres')),
      k8s.envVar('TIMESCALEDB_DBNAME', lib.getElse(me, 'postgres-dbname', me.namespace)),
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
