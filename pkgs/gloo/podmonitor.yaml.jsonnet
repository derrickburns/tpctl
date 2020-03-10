local prom = import '../../lib/prometheus.jsonnet';

function(config, prev, namespace)
  prom.Podmonitor(config, 'gloo-gateway-proxies', namespace, 'metrics', {
    'gateway-proxy': 'live',
    gloo: 'gateway-proxy',
  })
