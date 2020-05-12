local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:
    {
      image: 'keptn/configuration-service:0.6.2',
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
          memory: '64Mi',
        },
      },
      volumeMounts: [
        {
          mountPath: '/data/config',
          name: me.pkg,
        },
      ],
    },
  spec+: {
    template+: {
      spec+: {
        volumes: [
          {
            name: me.pkg,
            persistentVolumeClaim: {
              claimName: me.pkg,
            },
          },
        ],
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
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
    k8s.pvc(me, '100Mi'),
  ]
)
