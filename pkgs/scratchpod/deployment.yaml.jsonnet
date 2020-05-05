local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers: {
    image: 'ubuntu:latest',
    resources: {},
    volumeMounts: [
      {
        mountPath: '/data',
        name: 'storage',
      },
    ],
  },
  spec+: {
    template+: {
      spec+: {
        serviceAccountName: me.pkg,
        volumes: [
          {
            name: 'storage',
            persistentVolumeClaim: {
              claimName: me.pkg,
            },
          },
        ],
      },
    },
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))
