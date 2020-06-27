local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local kafkaconnect(me) = k8s.k( 'kafka.strimzi.io/v1beta1', 'KafkaConnect') + k8s.metadata(me.pkg, me.namespace) {
  metadata+: {
    annotations: {
      'strimzi.io/use-connector-resources': 'true',
    },
  },
  spec+: {
    bootstrapServers: 'kafka-kafka-bootstrap.%s.svc.cluster.local:9093' % me.namespace,
    image: 'tidepool/connect-debezium',
    replicas: 1,
    tls: {
      trustedCertificates: [
        {
          certificate: 'ca',
          secretName: kafka-cluster-ca-cert
        },
      ],
    },
    config: {
      config.storage.replication.factor: 1,
      offset.storage.replication.factor: 1,
      status.storage.replication.factor: 1,
      config.providers: 'file',
      config.providers.file.class: 'org.apache.kafka.common.config.provider.FileConfigProvider',
    },
    externalConfiguration: {
      volumes: [{
        name: 'connector-config',
        secret: {
          secretName: me.pkg, 
        }
      }],
    },
  },
};

local kafkaconnector(me) = k8s.k( 'kafka.strimzi.io/v1alpha1','KafkaConnector') + me.metadata( me.pkg, me.namespace) {
  metadata+: {
    labels+: {
      'strimzi.io/cluster': me.pkg,
    },
  },
  spec+: {
    class: 'io.debezium.connector.mongodb.MongoDbConnector',
    // see https://debezium.io/documentation/reference/connectors/mongodb.html#mongodb-connector-properties
    config: {
      "mongodb.name": "test",
      "mongodb.hosts": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:hosts}",
      "mongodb.user": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:user}",
      "mongodb.password": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:password}",
      "mongodb.ssl.enabled": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:ssl}",
      "collection.whitelist": "deviceData[.]*", 
    },
    tasksMax: 1,
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    kafkaconnect(me),
    kafkaconnector(me),
  ]
)
