local prom = import '../../lib/prometheus.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local podmonitor(config, me) = prom.Podmonitor(config, me, 'admin-http', {
  app: 'jaeger',
  'app.kubernetes.io/component': 'collector',
});

function(config, prev, namespace, pkg) podmonitor(config, common.package(config, prev, namespace, pkg))
