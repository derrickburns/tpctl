local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local containerPort = 8080;

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/kafka-data-import:latest',
    env: [
      k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
      k8s.envVar('KAFKA_TOPIC', lib.getElse(me, 'kafka-topic', me.namespace + '-' + 'data')),
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

local virtualService(me) = k8s.k('gateway.solo.io/v1', 'VirtualService') {
  metadata+: {
    name: 'kafka-data-import-virtual-service',
    namespace: me.namespace,
    labels: {
      namespace: me.namespace,
      protocol: 'http',
      type: 'internal',
    },
  },
  spec: {
    displayName: 'kafka-data-import-virtual-service',
    virtualHost: {
      domains: [
        '%s.%s-shadow' % [me.namespace, me.config.cluster.metadata.domain],
      ],
      routes: [
        {
          delegateAction: {
            selector: {
              labels: {
                app: 'tidepool-shadow',
                namespace: me.namespace,
              },
            },
          },
          matchers: [
            {
              prefix: '/',
            },
          ],
        },
      ],
    },
  },
};


function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
    gloo.simpleRoutetable(me, { app: 'tidepool-shadow' }, prefix='/', noauth=true),
    virtualService(me),
    gloo.kubeupstream(me),
  ]
)
