local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'flux.rules',
    rules: [
      {
        alert: 'FluxFailedSyncingManifests',
        annotations: {
          summary: 'Flux failed to sync manifests.',
          description: 'Flux failed to sync {{ $value }} manifest(s).',
          dashboard_url: 'https://grafana.%s/d/vJMuruVWk/weave-flux?orgId=1' % me.config.cluster.metadata.domain,
        },
        expr: 'flux_daemon_sync_manifests{success="false"} > 0',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'flux', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    prometheusRule(me),
  ]
)
