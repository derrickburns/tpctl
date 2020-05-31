local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local rolebinding1(me) = k8s.rolebinding(me) {
  roleRef: {
    kind: 'ClusterRole',
    name: 'strimzi-entity-operator',
  }
};

local rolebinding2(me) = k8s.rolebinding(me) {
  roleRef: {
    kind: 'ClusterRole',
    name: 'strimzi-cluster-operator-namespaced'
  }
};

local rolebinding3(me) = k8s.rolebinding(me) {
  roleRef: {
    kind: 'ClusterRole',
    name: 'strimzi-topic-operator',
  }
};

local deployment(me) = k8s.deployment(me) {
  _serviceAccount: true,
  _containers:: {
    args: [
      '/opt/strimzi/bin/cluster_operator_run.sh',
    ],
    env: [
      {
        name: 'STRIMZI_NAMESPACE',
        valueFrom: {
          fieldRef: {
            fieldPath: 'metadata.namespace',
          },
        },
      },
      {
        name: 'STRIMZI_FULL_RECONCILIATION_INTERVAL_MS',
        value: '120000',
      },
      {
        name: 'STRIMZI_OPERATION_TIMEOUT_MS',
        value: '300000',
      },
      {
        name: 'STRIMZI_DEFAULT_TLS_SIDECAR_ENTITY_OPERATOR_IMAGE',
        value: 'strimzi/kafka:0.18.0-kafka-2.5.0',
      },
      {
        name: 'STRIMZI_DEFAULT_TLS_SIDECAR_KAFKA_IMAGE',
        value: 'strimzi/kafka:0.18.0-kafka-2.5.0',
      },
      {
        name: 'STRIMZI_DEFAULT_KAFKA_EXPORTER_IMAGE',
        value: 'strimzi/kafka:0.18.0-kafka-2.5.0',
      },
      {
        name: 'STRIMZI_DEFAULT_CRUISE_CONTROL_IMAGE',
        value: 'strimzi/kafka:0.18.0-kafka-2.5.0',
      },
      {
        name: 'STRIMZI_DEFAULT_TLS_SIDECAR_CRUISE_CONTROL_IMAGE',
        value: 'strimzi/kafka:0.18.0-kafka-2.5.0',
      },
      {
        name: 'STRIMZI_KAFKA_IMAGES',
        value: '2.4.0=strimzi/kafka:0.18.0-kafka-2.4.0\n2.4.1=strimzi/kafka:0.18.0-kafka-2.4.1\n2.5.0=strimzi/kafka:0.18.0-kafka-2.5.0\n',
      },
      {
        name: 'STRIMZI_KAFKA_CONNECT_IMAGES',
        value: '2.4.0=strimzi/kafka:0.18.0-kafka-2.4.0\n2.4.1=strimzi/kafka:0.18.0-kafka-2.4.1\n2.5.0=strimzi/kafka:0.18.0-kafka-2.5.0\n',
      },
      {
        name: 'STRIMZI_KAFKA_CONNECT_S2I_IMAGES',
        value: '2.4.0=strimzi/kafka:0.18.0-kafka-2.4.0\n2.4.1=strimzi/kafka:0.18.0-kafka-2.4.1\n2.5.0=strimzi/kafka:0.18.0-kafka-2.5.0\n',
      },
      {
        name: 'STRIMZI_KAFKA_MIRROR_MAKER_IMAGES',
        value: '2.4.0=strimzi/kafka:0.18.0-kafka-2.4.0\n2.4.1=strimzi/kafka:0.18.0-kafka-2.4.1\n2.5.0=strimzi/kafka:0.18.0-kafka-2.5.0\n',
      },
      {
        name: 'STRIMZI_KAFKA_MIRROR_MAKER_2_IMAGES',
        value: '2.4.0=strimzi/kafka:0.18.0-kafka-2.4.0\n2.4.1=strimzi/kafka:0.18.0-kafka-2.4.1\n2.5.0=strimzi/kafka:0.18.0-kafka-2.5.0\n',
      },
      {
        name: 'STRIMZI_DEFAULT_TOPIC_OPERATOR_IMAGE',
        value: 'strimzi/operator:0.18.0',
      },
      {
        name: 'STRIMZI_DEFAULT_USER_OPERATOR_IMAGE',
        value: 'strimzi/operator:0.18.0',
      },
      {
        name: 'STRIMZI_DEFAULT_KAFKA_INIT_IMAGE',
        value: 'strimzi/operator:0.18.0',
      },
      {
        name: 'STRIMZI_DEFAULT_KAFKA_BRIDGE_IMAGE',
        value: 'strimzi/kafka-bridge:0.16.0',
      },
      {
        name: 'STRIMZI_DEFAULT_JMXTRANS_IMAGE',
        value: 'strimzi/jmxtrans:0.18.0',
      },
      {
        name: 'STRIMZI_LOG_LEVEL',
        value: 'INFO',
      },
    ],
    image: 'strimzi/operator:0.18.0',
    livenessProbe: {
      httpGet: {
        path: '/healthy',
        port: 'http',
      },
      initialDelaySeconds: 10,
      periodSeconds: 30,
    },
    ports: [
      {
        containerPort: 8080,
        name: 'http',
      },
    ],
    readinessProbe: {
      httpGet: {
        path: '/ready',
        port: 'http',
      },
      initialDelaySeconds: 10,
      periodSeconds: 30,
    },
    resources: {
      limits: {
        cpu: '1000m',
        memory: '384Mi',
      },
      requests: {
        cpu: '200m',
        memory: '384Mi',
      },
    },
  },
};


function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceAccount(me),
    rolebinding1(me),
    rolebinding2(me),
    rolebinding3(me),
    deployment(me),
  ]
)
