local common = import '../../lib/common.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'envoy.rules',
    rules: [
      {
        alert: 'EnvoyResponse5xx',
        annotations: {
          summary: 'Envoy high rate of 5xx.',
          description: 'Envoy error rate for the upstream `{{ $labels.namespace }}/{{ $labels.envoy_cluster_name }}` is above 1% for the past 2 minutes.',
          dashboard_url: 'https://grafana.%s/d/gloo_upstreams/gloo-upstreams?orgId=1&refresh=5s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(rate(envoy_cluster_upstream_rq_xx{envoy_response_code_class="5"}[2m])) by (envoy_cluster_name, namespace)  / sum(rate(envoy_cluster_upstream_rq_xx[2m])) by (envoy_cluster_name, namespace)* 100 > 1',
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
