local common = import '../../../../lib/common.jsonnet';
local prometheus = import '../../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'shoreline.rules',
    rules: [
      {
        alert: 'TidepoolShorelineMarketoConfigInvalid',
        annotations: {
          message: 'Marketo config is invalid for the pod: {{ $labels.pod }} in the namespace: {{ $labels.namespace }}.',
          dashboard: 'https://grafana.%s/d/5sv7jfiGk/shoreline?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(tidepool_shoreline_marketo_config_valid) by (namespace, pod)  == 0',
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'TidepoolShoreline5xx',
        annotations: {
          message: 'High count({{ $value }}) of {{ $labels.status_code }} with the reason: {{ $labels.status_reason }} by the Shoreline pod: {{ $labels.pod }} in the namespace: {{ $labels.namespace }}.',
          dashboard: 'https://grafana.%s/d/5sv7jfiGk/shoreline?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(tidepool_shoreline_failed_status_count{status_code=~"^5.*"}[1m])) by (status_reason, status_code, namespace, pod) > 0',
        'for': '30s',
        labels: {
          severity: 'critical',
        },
      },
    ],
sum(increase(tidepool_shoreline_failed_status_count
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'tidepool-shoreline', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name != 'shared'
  then [
    prometheusRule(me),
  ]
  else {}
)
