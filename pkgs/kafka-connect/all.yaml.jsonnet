local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local kafkaconnect(me) = k8s.k( 'kafka.strimzi.io/v1beta1', 'KafkaConnect') + k8s.metadata(me.pkg, me.namespace) {
  metadata+: {
    annotations: {
      'strimzi.io/use-connector-resources': 'true',
    },
  },
  spec+: lib.merge( {
    bootstrapServers: 'kafka-kafka-bootstrap.%s.svc.cluster.local:9093' % me.namespace,
    image: 'tidepool/connect-debezium:0.1.0',
    imagePullPolicy: 'Always',
    replicas: 1,
    tls: {
      trustedCertificates: [
        {
          secretName: 'kafka-cluster-ca-cert',
          certificate: 'ca.crt'
        },
      ],
    },
    config: {
      'config.storage.replication.factor': 1,
      'offset.storage.replication.factor': 1,
      'status.storage.replication.factor': 1,
      'config.providers': 'file',
      'config.providers.file.class': 'org.apache.kafka.common.config.provider.FileConfigProvider',
    },
    externalConfiguration: {
      volumes: [{
        name: 'connector-config',
        secret: {
          secretName: me.pkg, 
        }
      }],
    },
  }, lib.getElse( me, 'spec', {})),
};

local kafkaconnector(me, name, config) = k8s.k( 'kafka.strimzi.io/v1alpha1','KafkaConnector') + k8s.metadata( name, me.namespace) {
  "class": "MongoDbConnector",
  spec+: lib.merge( {
    // see https://debezium.io/documentation/reference/connectors/mongodb.html#mongodb-connector-properties
    config: {
      "connector.type": "source",
      "mongodb.name": name,
      "mongodb.hosts": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:Addresses}",
      "mongodb.user": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:Username}",
      "mongodb.password": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:Password}",
      "mongodb.ssl.enabled": "${file:/opt/kafka/external-configuration/connector-config/debezium-mongo-credentials.properties:Tls}",
      //"collection.whitelist": "data.deviceData", 
      //"database.whitelist": "data", 
    },
    tasksMax: 1,
  }, config) 
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    kafkaconnect(me),
    std.mapWithKey( function(n, v) kafkaconnector(me, n, v), lib.getElse(me, 'connectors', {})) 
  ]
)
