local common = import '../../../lib/common.jsonnet';
local lib = import '../../../lib/lib.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'export.rules',
    rules: [
      {
        alert: 'TidepoolExport408',
        annotations: {
          summary: 'Export is timing out requests.',
          description: 'High count of `{{ $labels.status_code }}s` for exports using the export format `{{ $labels.export_format }}` the last 5 minutes.',
          dashboard_url: 'https://grafana.%s/d/HNqFvjVGk/tidepool-services-export?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum by(export_format, status_code) (increase(tidepool_export_status_count{status_code="408"}[5m])) > 0',
        labels: {
          severity: 'info',
        },
      },
      {
        alert: 'TidepoolExport5xx',
        annotations: {
          summary: 'High count of 5xx.',
          description: 'High count of `{{ $labels.status_code }}s` for exports using the export format `{{ $labels.export_format }}` for the past minute.',
          dashboard_url: 'https://grafana.%s/d/HNqFvjVGk/tidepool-services-export?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(increase(tidepool_export_status_count{status_code=~"^5.*"}[1m])) by (status_reason, export_format) > 0',
        labels: {
          severity: 'warning',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'tidepool-export', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
