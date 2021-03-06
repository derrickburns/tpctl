local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local kafka(me) = k8s.k('kafka.strimzi.io/v1beta1', 'Kafka') + k8s.metadata(me.pkg, me.namespace) {
  spec+: lib.merge({
    entityOperator: {
      topicOperator: {},
      userOperator: {},
    },
    kafka: {
      config: {
        'log.message.format.version': '2.5',
        'offsets.topic.replication.factor': 1,
        'transaction.state.log.min.isr': 1,
        'transaction.state.log.replication.factor': 1,
      },
      listeners: {
        plain: {},
        tls: {},
      },
      replicas: 3,
      storage: {
        type: 'jbod',
        volumes: [
          {
            deleteClaim: false,
            id: 0,
            size: '100Gi',
            type: 'persistent-claim',
          },
        ],
      },
      version: '2.5.0',
    },
    zookeeper: {
      replicas: 3,
      storage: {
        deleteClaim: false,
        size: '100Gi',
        type: 'persistent-claim',
      },
    },
  }, lib.getElse(me, 'spec', {})),
};

local externalname(me) = k8s.externalname(me {
  target: {
    name: 'kafka-kafka-bootstrap.%s' % me.namespace,
    port: 9093,
  },
});

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    kafka(me),
    externalname(me),
  ]
)
