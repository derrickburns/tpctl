local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(
  me,
  containers={
    image: 'tidepool/admin-site:latest',
    imagePullPolicy: 'Always',
    env: [
      k8s.envSecret('SERVER_SECRET', 'server', 'ServiceAuth'),
      k8s.envVar('API_HOST', 'http://internal.%s' % me.namespace),
    ],
    ports: [{
      containerPort: 8080,
    }],
  },
);

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(8080, 8080)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
