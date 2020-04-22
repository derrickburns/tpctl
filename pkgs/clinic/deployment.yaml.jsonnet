local common = import '../../lib/common.jsonnet';
local flux = import '../../lib/flux.jsonnet';

local deployment(me) = flux.deployment(me) {
  _containers:: [
    {
      image: 'tidepool/clinic:latest',
      imagePullPolicy: 'Always',
      name: me.pkg,
    },
  ],
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))
