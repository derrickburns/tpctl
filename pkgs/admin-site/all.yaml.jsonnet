local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: [{
    name: me.pkg,
    image: 'tidepool/admin-site:latest',
    imagePullPolicy: 'Always',
    ports: [{
      containerPort: 8080,
    }],
  }],
};

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
