local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _secretNames:: ['hasura'],
  _containers:: {
    env: [
      k8s.envSecret('HASURA_GRAPHQL_DATABASE_URL', $._secretNames[0], 'HASURA_GRAPHQL_DATABASE_URL'),
      k8s.envVar( 'HASURA_GRAPHQL_ENABLE_CONSOLE', 'true'),
    ],
    image: 'hasura/graphql-engine:v1.2.2',
    ports: [
      {
        containerPort: 8080,
        protocol: 'TCP',
      },
    ],
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(80)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    service(me),
    deployment(me),
  ]
)
