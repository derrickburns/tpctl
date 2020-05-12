local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers: {
    env: [
      {
        name: 'PUBSUB_URL',
        value: 'nats://keptn-nats-cluster',
      },
      {
        name: 'PUBSUB_IMPL',
        value: 'nats',
      },
    ],
    image: 'keptn/eventbroker-go:0.6.2',
    ports: [
      {
        containerPort: 8080,
      },
    ],
    resources: {
      limits: {
        cpu: '500m',
        memory: '128Mi',
      },
      requests: {
        cpu: '50m',
        memory: '32Mi',
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
        port: 80,
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
