local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local grpcPort = 9292;

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(grpcPort, 'grpc', 'grpc')],
  },
};

local configmap(me) = k8s.configmap(me) {
  data+: {
    'liftbridge.yaml': std.manifestJson({
      listen: '0.0.0.0:%s' % grpcPort,
      'logging.level': "debug",
      'nats.servers': [ "nats://%s-nats.%s.svc:4222" % [me.pkg, me.namespace] ],
      'clustering.min.insync.replicas': 1
    }),
  },
};

local statefulset(me) = k8s.statefulset(me) {
  _containers:: {
    image: 'liftbridge/liftbridge:v1.0.0',
    ports: [
      {
        containerPort: grpcPort,
        name: 'grpc',
      },
    ],
    readinessProbe: {
      exec: {
        command: [
          '/bin/grpc_health_probe',
          '-service=proto.API',
          '-addr=:%s' % grpcPort,
        ],
      },
      initialDelaySeconds: 5,
    },
    volumeMounts: [
      {
        mountPath: '/data',
        name: 'liftbridge-data',
      },
      {
        mountPath: '/etc/liftbridge.yaml',
        name: 'liftbridge-config',
        subPath: 'liftbridge.yaml',
      },
    ],
  },
  spec+: {
    podManagementPolicy: 'Parallel',
    replicas: 3,
    serviceName: me.pkg,
    template+: {
      spec+: {
        volumes: [
          {
            configMap: {
              name: me.pkg,
            },
            name: 'liftbridge-config',
          },
        ],
      },
    },
    volumeClaimTemplates: [
      {
        metadata: {
          name: 'liftbridge-data',
        },
        spec: {
          accessModes: [
            'ReadWriteOnce',
          ],
          resources: {
            requests: {
              storage: '5Gi',
            },
          },
          storageClassName: 'gp2-expanding',
        },
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    configmap(me),
    service(me),
    statefulset(me),
  ]
)
