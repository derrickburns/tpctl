local prom = import '../../lib/prometheus.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local podmonitor(config, me) = prom.Podmonitor(config, me, 'metrics', {
  'gateway-proxy': 'live',
  gloo: 'gateway-proxy',
});

function(config, prev, namespace, pkg) podmonitor(config, common.package(config, prev, namespace, pkg))
