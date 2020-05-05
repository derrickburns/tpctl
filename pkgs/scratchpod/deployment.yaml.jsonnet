local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            image: 'ubuntu/ubuntu:latest',
            name: me.pkg,
            resources: {
              limits: {
                cpu: 1,
                memory: '1Gi',
              },
              requests: {
                cpu: '100m',
                memory: '500Mi',
              },
            },
            volumes: [
              {
                name: 'storage',
                persistentVolumeClaim: {
                  claimName: me.pkg,
                },
              },
            ],
          },
        ],
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    deployment(me),
  ]
)
