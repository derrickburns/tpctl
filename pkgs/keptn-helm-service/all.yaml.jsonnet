local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment = k8s.deployment(
  me,
  containers={
    env: [
      {
        name: 'CONFIGURATION_SERVICE',
        value: 'http://keptn-configuration-service.%s.svc.cluster.local:8080' % me.namespace,
      },
      {
        name: 'EVENTBROKER',
        value: 'http://keptn-event-broker.%s.svc.cluster.local/keptn' % me.namespace,
      },
      {
        name: 'API',
        value: 'ws://keptn-api-service.%s.svc.cluster.local:8080' % me.namespace,
      },
      {
        name: 'ENVIRONMENT',
        value: 'production',
      },
      {
        name: 'PRE_WORKFLOW_ENGINE',
        value: 'true',
      },
      {
        name: 'CANARY',
        value: 'deployment',
      },
    ],
    image: 'keptn/helm-service:0.6.2',
    ports: [
      {
        containerPort: 8080,
      },
    ],
    resources: {
      limits: {
        cpu: '1000m',
        memory: '512Mi',
      },
      requests: {
        cpu: '50m',
        memory: '128Mi',
      },
    },
  },
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
        port: 8080,
        protocol: 'TCP',
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
