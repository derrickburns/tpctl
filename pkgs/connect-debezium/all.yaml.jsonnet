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
          secretName: me.pkg,
        },
      ],
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    kakfaconnect(me),
  ]
)
