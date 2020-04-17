local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

local servicemonitor(config, me) = prom.Servicemonitor(config, me, 8888);

function(config, prev, namespace, pkg) servicemonitor(config, common.package(config, prev, namespace, pkg))
