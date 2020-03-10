local prom = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace) prom.Podmonitor(condig, 'gloo-gateway-proxies', namespace, 'metrics', {
  'gateway-proxy': 'live',
  gloo: 'gateway-proxy',
})
