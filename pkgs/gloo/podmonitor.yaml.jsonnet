local prom = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace) prom.Podmonitor('gloo-gateway-proxies', namespace, 'metrics', {
  'gateway-proxy': 'live',
  gloo: 'gateway-proxy',
})
