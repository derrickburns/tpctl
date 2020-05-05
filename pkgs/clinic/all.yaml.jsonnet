local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/clinic:latest',
    env: [
      k8s.envSecret('TIDEPOOL_STORE_SCHEME', 'mongo', 'Scheme'),
      k8s.envSecret('TIDEPOOL_STORE_USERNAME', 'mongo', 'Username'),
      k8s.envSecret('TIDEPOOL_STORE_PASSWORD', 'mongo', 'Password'),
      k8s.envSecret('TIDEPOOL_STORE_ADDRESSES', 'mongo', 'Addresses'),
      k8s.envSecret('TIDEPOOL_STORE_OPT_PARAMS', 'mongo', 'OptParams'),
      k8s.envSecret('TIDEPOOL_STORE_TLS', 'mongo', 'Tls'),
      k8s.envVar('TIDEPOOL_STORE_DATABASE', 'clinic'),
      k8s.envVar('TIDEPOOL_KETO_HOST', 'keto'),
      k8s.envVar('TIDEPOOL_KETO_PORT', '8080'),
      k8s.envVar('TIDEPOOL_KETO_TEMP', 'temp'),
    ],
  },
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
    gloo.simpleRoutetable(me, {app: 'tidepool'}, prefix='/clinics'),
    gloo.kubeupstream(me),
  ]
)
