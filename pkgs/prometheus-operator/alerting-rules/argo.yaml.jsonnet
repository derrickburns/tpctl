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
          description: 'The API Test in {{ $labels.env }} failed.',
          dashboard_url: 'https://argo.shared.tidepool.org/workflows/qa?label=workflows.argoproj.io%2Fcron-workflow%3Dapi-tests-default-{{ $labels.env }}',
        },
        expr: 'sum(argo_workflows_api_tests_status) by (env) == 0',
        'for': '1m',
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
