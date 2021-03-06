local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

local podmonitor(me) = prom.Podmonitor(me, 'metrics', {
  'gateway-proxy': 'live',
  gloo: 'gateway-proxy',
});

function(config, prev, namespace, pkg) podmonitor(common.package(config, prev, namespace, pkg))
