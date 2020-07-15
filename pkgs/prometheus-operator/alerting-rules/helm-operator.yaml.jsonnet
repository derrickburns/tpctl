local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig = [
  {
    name: 'helm-operator.rules',
    rules: [
      {
        alert: 'HelmOperatorFailedFetchChart',
        annotations: {
          message: 'Failed to fetch chart for the release: {{ $labels.release_name }} in the namespace: {{ $labels.namespace }}. It has not been fetchable for the past minute.',
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
          message: 'Failed to release chart for the release: {{ $labels.release_name }} in the namespace: {{ $labels.namespace }}. It has not been released for the past minute.',
        },
        expr: 'flux_helm_operator_release_condition_info{condition="ChartFetched"} < 0',
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'HelmOperatorUpgradingChart',
        annotations: {
          message: 'The release: {{ $labels.release_name }} in the namespace: {{ $labels.namespace }} is being upgraded for more than 5 minutes.',
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
          message: 'The release: {{ $labels.release_name }} in the namespace: {{ $labels.namespace }} is being RolledBack for more than 5 minutes.',
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

local prometheusRule(me) = prometheus.prometheusRule(me, 'helm-operator', groupConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
