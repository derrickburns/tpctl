local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'argo.rules',
    rules: [
      {
        alert: 'ApiTestFailed',
        annotations: {
          summary: 'API Test Failed.',
          description: 'The API Test ${labels.entrypoint} failed.',
          dashboard_url: 'https://argo.shared.tidepool.org/workflows',
        },
        expr: 'sum(increase(argo_workflow_status_phase{phase=~"(Error|Failed)", entrypoint=~"api-tests.*"}[10m])) by (entrypoint)',
        'for': '10m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'argo', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    prometheusRule(me),
  ]
  else {}
)
