local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(
  me,
  containers={
    args: [
      '--mode=app',
      '--weave=false',
    ],
    command: [
      '/home/weave/scope',
    ],
    env: [],
    image: 'docker.io/weaveworks/scope:1.13.0',
    ports: [
      {
        containerPort: 4040,
        protocol: 'TCP',
      },
    ],
  },
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [
      {
        name: 'app',
        port: 80,
        protocol: 'TCP',
        targetPort: 4040,
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);

  [
    deployment(me),
    service(me),
  ]
)
