local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(9292, 'grpc', 'grpc')],
  },
};

local natscluster(me) = k8s.k('nats.io/v1alpha2', 'NatsCluster') + k8s.metadata(me.namespace, me.pkg) {
  spec+: {
    natsConfig: {
      writeDeadline: '5s',
    },
    pod: {
      annotations: {
        'sidecar.istio.io/inject': 'false',
      },
      enableConfigReload: true,
      enableMetrics: true,
      metricsImage: 'synadia/prometheus-nats-exporter',
      metricsImageTag: '0.5.0',
      reloaderImage: 'connecteverything/nats-server-config-reloader',
      reloaderImagePullPolicy: 'IfNotPresent',
      reloaderImageTag: '0.6.0',
    },
    size: 3,
    version: '2.1.0',
  },
};

local statefulset(me) = k8s.statefulset(me) {
  _containers: {
    image: 'liftbridge:v1.0.0',
    ports: [
      {
        containerPort: 9292,
        name: 'grpc',
      },
    ],
    readinessProbe: {
      exec: {
        command: [
          '/bin/grpc_health_probe',
          '-service=proto.API',
          '-addr=:9292',
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
              name: 'config',
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
          storageClassName: 'liftbridge',
        },
      },
    ],
  },
};

local storageclass(me) = k8s.storageclass(me) {
  provisioner: 'kubernetes.io/host-path',
  reclaimPolicy: 'Retain',
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    storageclass(me),
    statefulset(me),
    natscluster(me),
  ]
)
