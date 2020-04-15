local lib = import '../../lib/lib.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

local servicemonitor(config, me) = prom.Servicemonitor(config, me, 8888);

function(config, prev, namespace, pkg) servicemonitor(config, lib.package(config, namespace, pkg))
