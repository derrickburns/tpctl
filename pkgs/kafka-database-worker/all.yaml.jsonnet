local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local global = import '../../lib/global.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../../lib/linkerd.jsonnet';

local containerPort = 8080;

local namespaced(ns, list) = [ns + '.' + x for x in list];

local list = [
  'data.data.deviceData',
  'clinician.clinic.clinicsClinicians',
  'clinic.clinic.clinic',
  'patient.clinic.clinicsPatients',
  'gatekeeper.gatekeeper.perms',
];

local deployment(me) = flux.deployment(me,
                                       containers={
                                         local timescalePkg = global.package(me.config, 'timescaledb-single'),

                                         image: 'tidepool/kafka-database-worker:latest',
                                         env: [
                                           k8s.envVar('KAFKA_BROKERS', lib.getElse(me, 'kafka-brokers', 'kafka-kafka-bootstrap.kafka.svc.cluster.local:9092')),
                                           k8s.envVar('KAFKA_TOPIC', lib.getElse(me, 'kafka-topic', std.join(',', namespaced(me.namespace, list)))),
                                           k8s.envVar('TIMESCALEDB_HOST', lib.getElse(me, 'postgres-host', 'timescaledb-single.%s.svc.cluster.local' % timescalePkg.namespace)),
                                           k8s.envVar('TIMESCALEDB_USER', lib.getElse(me, 'postgres-user', 'postgres')),
                                           k8s.envVar('TIMESCALEDB_DBNAME', lib.getElse(me, 'postgres-dbname', 'postgres')),
                                           k8s.envSecret('TIMESCALEDB_PASSWORD', 'timescaledb-single-passwords', 'postgres'),
                                         ],
                                         ports: [{
                                           containerPort: containerPort,
                                         }],
                                         resources: {
                                           limits: {
                                             cpu: '500',
                                             memory: '1000Mi',
                                           },
                                           requests: {
                                             cpu: '500m',
                                             memory: '500Mi',
                                           },
                                         },
                                       }) {
  spec+: {
    replicas: lib.getElse(me, 'replicas', 1),
    template+: linkerd.metadata(me, true) + {
      spec+: lib.merge({
        affinity: {
          nodeAffinity: k8s.nodeAffinity(values=['timescale']),
        },
        tolerations: [k8s.toleration(value='timescale')],
      }, lib.getElse(me, 'spec', {})),
    },
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
