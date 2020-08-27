local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'helm-operator.rules',
    rules: [
      {
        alert: 'HelmOperatorFailedFetchChart',
        annotations: {
          summary: 'Failed to fetch Helm chart.',
          description: 'Failed to fetch chart for the release {{ $labels.target_namespace }}/{{ $labels.release_name }}. The chart has not been available for the past minute.',
          dashboard_url: 'https://grafana.%s/d/c8qWijkGz/helm-operator?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'flux_helm_operator_release_condition_info{condition="ChartFetched"} < 1',
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'HelmOperatorFailedReleaseChart',
        annotations: {
          summary: 'Failed to release Helm chart.',
          description: 'Failed to release chart for the release {{ $labels.target_namespace }}/{{ $labels.release_name }}. The chart has not been released for the past minute.',
          dashboard_url: 'https://grafana.%s/d/c8qWijkGz/helm-operator?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'flux_helm_operator_release_condition_info{condition="Released"} < 0',
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'HelmOperatorUpgradingChart',
        annotations: {
          summary: 'Helm Chart is stuck upgrading.',
          description: 'The release {{ $labels.target_namespace }}/{{ $labels.release_name }} is being upgraded for more than 5 minutes.',
          dashboard_url: 'https://grafana.%s/d/c8qWijkGz/helm-operator?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'flux_helm_operator_release_condition_info{condition="Released"} == 0',
        'for': '5m',
        labels: {
          severity: 'warning',
        },
      },
      {
        alert: 'HelmOperatorRollingBackChart',
        annotations: {
          summary: 'Helm Chart is rolled back.',
          description: 'The release {{ $labels.target_namespace }}/{{ $labels.release_name }} is rolled back for more than 5 minutes.',
          dashboard_url: 'https://grafana.%s/d/c8qWijkGz/helm-operator?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'flux_helm_operator_release_condition_info{condition="RolledBack"} == 1',
        'for': '5m',
        labels: {
          severity: 'warning',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'helm-operator', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
