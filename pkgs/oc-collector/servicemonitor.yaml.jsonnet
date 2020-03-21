local lib = import '../../lib/lib.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';
local global = import '../../lib/global.jsonnet';

function(config, prev, namespace, pkg)
  if global.isEnabled(config, 'prometheus-operator')
  then prom.servicemonitor(lib.package(config, namespace, pkg), 8888)
  else {}
