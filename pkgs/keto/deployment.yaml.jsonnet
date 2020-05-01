local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/keto:latest',
    env: [
      k8s.envVar('TIDEPOOL_KETO_HOST', 'keto'),
      k8s.envVar('TIDEPOOL_KETO_PORT', '8080'),
    ],
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))
