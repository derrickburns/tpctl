local prom = import '../../lib/prometheus.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local podmonitor(config, me) = prom.Podmonitor(config, me, 'metrics', {
  'gateway-proxy': 'live',
  gloo: 'gateway-proxy',
});

function(config, prev, namespace, pkg) podmonitor(config, lib.package(config, namespace, pkg))
