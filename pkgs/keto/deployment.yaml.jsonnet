local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: {
    image: 'tidepool/keto:latest',
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))