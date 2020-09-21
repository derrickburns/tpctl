local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(
  me,
  serviceAccount=true,


  containers={
    image: lib.getElse(me, 'image', 'ubuntu:latest'),
    name: me.pkg,
    resources: {
      limits: {
        cpu: lib.getElse(me, 'limits.cpu', 1),
        memory: lib.getElse(me, 'limits.memory', '1Gi'),
      },
      requests: {
        cpu: '100m',
        memory: '1Gi',
      },
    },
    volumeMounts: [
      {
        mountPath: '/data',
        name: me.pkg,
      },
    ],
    args: [
      '-c',
      'while true; do sleep 30; done;',
    ],
    command: [
      '/bin/bash',
    ],
  },
  volumes=[
    {
      name: me.pkg,
      persistentVolumeClaim: {
        claimName: me.pkg,
      },
    },
  ]
);

function(config, prev, namespace, pkg) (deployment(common.package(config, prev, namespace, pkg)))
