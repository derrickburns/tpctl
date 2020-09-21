local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment = k8s.deployment(
  me,
  containers={
    env: [
      {
        name: 'EVENTBROKER_URI',
        value: 'keptn-event-broker.%s.svc.cluster.local' % me.namespace,
      },
      {
        name: 'DATASTORE_URI',
        value: 'keptn-mongo.%s.svc.cluster.local:8080' % me.namespace,
      },
      {
        name: 'CONFIGURATION_URI',
        value: 'keptn-configuration-service.%s.svc.cluster.local:8080' % me.namespace,
      },
      {
        name: 'SECRET_TOKEN',
        valueFrom: {
          secretKeyRef: {
            key: 'keptn-api-token',
            name: 'keptn-api-token',  // XXX who generates this
          },
        },
      },
    ],
    image: 'keptn/api:0.6.2',
    ports: [
      {
        containerPort: 8080,
      },
    ],
    resources: {
      limits: {
        cpu: '500m',
        memory: '256Mi',
      },
      requests: {
        cpu: '50m',
        memory: '64Mi',
      },
    },
  },
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
        name: 'http',
        port: 8080,
        protocol: 'TCP',
        targetPort: 8080,
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
