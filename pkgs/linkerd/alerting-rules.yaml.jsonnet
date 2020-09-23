local common = import '../../lib/common.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'linkerd.rules',
    rules: [
      {
        alert: 'LinkerdHighErrorRate',
        annotations: {
          summary: 'Linkerd high error rate.',
          description: 'Linkerd error rate for `{{ $labels.deployment }}{{ $labels.statefulset }}{{ $labels.daemonset }}` is above 1% for the past 5 minutes.',
          dashboard_url: 'https://grafana.%s/d/linkerd-topline/linkerd-topline?orgId=1&refresh=30s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(rate(request_errors_total[5m])) by (deployment, statefulset, daemonset) / sum(rate(request_total[5m])) by (deployment, statefulset, daemonset) * 100 > 1',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'linkerd', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
