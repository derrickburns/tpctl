local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    env: [
      {
        name: 'MONGO_DB_CONNECTION_STRING',
        value: 'mongodb://user:password@mongodb:27017/keptn',
      },
      {
        name: 'MONGO_DB_NAME',
        value: 'keptn',
      },
    ],
    image: 'keptn/mongodb-datastore:0.6.2',
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
    ports: [k8s.port(27017, 27017)],
  },
};

local distributor(me) = k8s.deployment(me) {
  metadata+: {
    name: 'mongodb-datastore-distributor',
  },
  spec+: {
    replicas: 1,
    selector: {
      matchLabels: {
        run: 'distributor',
      },
    },
    template+: {
      metadata: {
        labels: {
          run: 'distributor',
        },
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: 'PUBSUB_IMPL',
                value: 'nats',
              },
              {
                name: 'PUBSUB_URL',
                value: 'nats://keptn-nats-cluster.keptn.svc.cluster.local',
              },
              {
                name: 'PUBSUB_TOPIC',
                value: 'sh.keptn.>',
              },
              {
                name: 'PUBSUB_RECIPIENT',
                value: 'mongodb-datastore',
              },
              {
                name: 'PUBSUB_RECIPIENT_PATH',
                value: '/event',
              },
            ],
            image: 'keptn/distributor:0.6.2',
            name: 'distributor',
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
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
    service(me),
    distributor(me),
  ]
)

