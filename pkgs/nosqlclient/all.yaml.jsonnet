local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local containerPort = 3000;

local deployment(me) = k8s.deployment(
  me,
  containers={
    env: [
      k8s.envVar('INSTALL_MONGO', 'false'),
      k8s.envSecret('MONGO_SCHEME', 'mongo', 'Scheme'),
      k8s.envSecret('MONGO_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('MONGO_PASSWORD', 'mongo', 'Password', true),
      k8s.envSecret('MONGO_ADDRESSES', 'mongo', 'Addresses'),
      k8s.envSecret('MONGO_OPT_PARAMS', 'mongo', 'OptParams'),
      k8s.envSecret('MONGO_TLS', 'mongo', 'Tls'),
    ],
    image: 'tidepool/nosqlclient:2.3.2',
    name: me.pkg,
    ports: [
      {
        containerPort: containerPort,
      },
    ],
  }
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(3000, containerPort)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
