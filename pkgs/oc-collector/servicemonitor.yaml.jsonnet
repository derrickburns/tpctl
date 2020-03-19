local lib = import '../../lib/lib.jsonnet';
local prom = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace, pkg)
  if lib.isEnabledAt(config, 'pkgs.prometheusOperator')
  then prom.servicemonitor(lib.package(config, namespace, pkg), 8888)
  else {}
