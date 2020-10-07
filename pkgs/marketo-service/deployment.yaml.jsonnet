local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local port = 8080;

local deployment(me) = flux.deployment(
  me,
  containers={
    image: 'tidepool/marketo-service:latest',
    env: [
      k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
      k8s.envVar('KAFKA_TOPIC', lib.getElse(me, 'kafka-topic', 'marketo')),
      k8s.envVar('KAFKA_PREFIX', lib.getElse(me, 'kafka-prefix', me.namespace + '-')),
      k8s.envSecret('TIDEPOOL_STORE_SCHEME', 'mongo', 'Scheme'),
      k8s.envSecret('TIDEPOOL_STORE_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('TIDEPOOL_STORE_PASSWORD', 'mongo', 'Password'),
      k8s.envSecret('TIDEPOOL_STORE_ADDRESSES', 'mongo', 'Addresses'),
      k8s.envSecret('TIDEPOOL_STORE_OPT_PARAMS', 'mongo', 'OptParams'),
      k8s.envSecret('TIDEPOOL_STORE_TLS', 'mongo', 'Tls'),
      k8s.envVar('TIDEPOOL_STORE_DATABASE', 'user'),
      k8s.envSecret('MARKETO_SECRET', 'marketo', 'Secret', false),
      k8s.envSecret('MARKETO_ID', 'marketo', 'ID', false),
      k8s.envSecret('MARKETO_URL', 'marketo', 'URL', false),
      k8s.envConfigmap('MARKETO_CLINIC_ROLE', 'marketo', 'ClinicRole', true),
      k8s.envConfigmap('MARKETO_PATIENT_ROLE', 'marketo', 'PatientRole', true),
      k8s.envConfigmap('MARKETO_TIMEOUT', 'marketo', 'Timeout', true),
    ],
    ports: [{
      containerPort: port,
    }],
  }
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
  ]
)