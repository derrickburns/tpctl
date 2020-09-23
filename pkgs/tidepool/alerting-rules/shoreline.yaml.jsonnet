local common = import '../../../lib/common.jsonnet';
local lib = import '../../../lib/lib.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'shoreline.rules',
    rules: [
      {
        alert: 'TidepoolShoreline5xx',
        annotations: {
          summary: 'High count of 5xx.',
          description: 'High count of `{{ $labels.status_code }}s` with the reason `{{ $labels.status_reason }}`.',
          dashboard_url: 'https://grafana.%s/d/5sv7jfiGk/shoreline?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(tidepool_shoreline_failed_status_count{status_code=~"^5.*"}[2m])) by (status_reason, status_code) > 0',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'TidepoolShorelineMarketoConfigInvalid',
        annotations: {
          summary: 'Invalid Marketo config.',
          description: 'Marketo config is invalid for the pod {{ $labels.namespace }}/{{ $labels.pod }}.',
          dashboard_url: 'https://grafana.%s/d/5sv7jfiGk/shoreline?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(tidepool_shoreline_marketo_config_valid) by (namespace, pod) == 0',
        labels: {
          severity: 'warning',
        },
      },
      {
        alert: 'TidepoolShorelineFailedMarketoUpload',
        annotations: {
          summary: 'Failed Marketo uploads.',
          description: 'High count({{ $value }}) of failed Marketo uploads by the pod {{ $labels.namespace }}/{{ $labels.pod }}.',
          dashboard_url: 'https://grafana.%s/d/5sv7jfiGk/shoreline?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(tidepool_shoreline_failed_marketo_upload_total[1m])) by (namespace, pod) > 0',
        labels: {
          severity: 'warning',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'tidepool-shoreline', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
