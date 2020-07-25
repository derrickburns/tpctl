local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig = [
  {
    name: 'envoy.rules',
    rules: [
      {
        alert: 'EnvoyResponse5xx',
        annotations: {
          message: 'High count({{ $value }}) of 5xx by the upstream {{ $labels.envoy_cluster_name }} in the namespace {{ $labels.namespace }}.',
        },
        expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5"}[1m])) by (envoy_cluster_name, namespace) > 0',  // Replace 0 with an acceptable value
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'envoy', groupConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
