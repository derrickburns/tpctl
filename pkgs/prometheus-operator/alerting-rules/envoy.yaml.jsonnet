local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'envoy.rules',
    rules: [
      {
        alert: 'EnvoyResponse5xx',
        annotations: {
          summary: 'High count of 5xx.',
          description: 'High count of 5xx by the upstream {{ $labels.namespace }}/{{ $labels.envoy_cluster_name }}.',
          dashboard_url: 'https://grafana.%s/d/gloo_upstreams/gloo-upstreams?orgId=1&refresh=5s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5"}[1m])) by (envoy_cluster_name, namespace) > 0',  // Replace 0 with an acceptable value
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'envoy', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
