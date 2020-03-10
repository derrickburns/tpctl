local prom  = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace)
  prom.Podmonitor(config, 'cadvisor', namespace, 8080, { name: 'cadvisor' })
