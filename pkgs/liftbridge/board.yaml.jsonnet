local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    command: [
      '/usr/bin/natsboard',
    ],
    env: [
      {
        name: 'WAIT_FOR_HOST',
        value: '%s-nats-mgmt.%s.svc.cluster.local' % [ me.pkg, me.namespace],
      },
      {
        name: 'WAIT_FOR_PORT',
        value: '8222',
      },
      {
        name: 'NATS_MON_URL',
        value: 'http://%s-nats-mgmt.%s.svc.cluster.local:8222' % [ me.pkg, me.namespace ],
      },
    ],
    image: 'natsboard',
    ports: [
      {
        containerPort: 3000,
        name: 'http',
      },
    ],
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(3000, 3000)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
    service(me),
  ]
)
