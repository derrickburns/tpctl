local prom = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace, pkg) 
  prom.Podmonitor(config, 'jaeger-collector', namespace, 'admin-http', {
    app: 'jaeger',
    'app.kubernetes.io/component': 'collector',
  })
