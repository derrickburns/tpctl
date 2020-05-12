local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local deployment(me) = k8s.deployment(me) {
        _containers: {
          {
            envFrom: [
              {
                secretRef: {
                  name: 'bridge-credentials',
                  optional: true,
                },
              },
            ],
            image: 'keptn/bridge2:0.6.2',
            ports: [
              {
                containerPort: 3000,
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
          },
      },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
        port: 8080,
        protocol: 'TCP',
        targetPort: 3000,
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

