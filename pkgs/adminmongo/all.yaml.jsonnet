local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    image: 'mrvautin/adminmongo:latest',
    imagePullPolicy: 'Always',
    env: [
      k8s.envSecret('DB_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('DB_PASSWORD', 'mongo', 'Password', true),
      k8s.envSecret('DB_HOST', 'mongo', 'Addresses'),
      k8s.envVar('DB_NAME', 'user'),
      k8s.envVar('DB_PORT', '27017'),
      k8s.envVar('CONN_NAME', 'local'),
    ],
    ports: [{
      containerPort: 1234,
    }],
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 1234)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
