local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'flux.rules',
    rules: [
      {
        alert: 'FluxFailedSyncingManifests',
        annotations: {
          message: 'Flux failed to sync {{ $value }} manifest(s).',
        },
        expr: 'flux_daemon_sync_manifests{success="false"} > 0',
        'for': '30s',
        labels: {
          severity: 'critical',
          dashboard: 'https://grafana.%s/d/vJMuruVWk/weave-flux?orgId=1' % me.config.cluster.metadata.domain,
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
