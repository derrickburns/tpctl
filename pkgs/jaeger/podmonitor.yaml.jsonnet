local prom = import '../../lib/prometheus.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local podmonitor(me) = prom.Podmonitor(config, me, 'admin-http', {
  app: 'jaeger',
  'app.kubernetes.io/component': 'collector',
});

function(config, prev, namespace, pkg) podmonitor(lib.package(config, namespace, pkg))
