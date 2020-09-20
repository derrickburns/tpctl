local common = import '../../../lib/common.jsonnet';
local lib = import '../../../lib/lib.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'atlassian-backups.rules',
    rules: [
      {
        alert: 'AtlassianBackupFailed',
        annotations: {
          summary: 'Atlassian backup failed.',
          description: '{{ $labels.backup_name }} backup failed.',
          dashboard_url: 'https://argo.%s.tidepool.org/workflows/tools' % me.config.cluster.metadata.domain,
        },
        expr: 'sum(argo_workflows_atlassian_backup_status) by (backup_name) == 0',
        'for': '10m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'atlassian-backups', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.getElse(me, 'opsMonitoring', false)
  then [
    prometheusRule(me),
  ]
  else {}
)
