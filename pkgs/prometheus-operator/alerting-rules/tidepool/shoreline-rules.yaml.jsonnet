local common = import '../../../../lib/common.jsonnet';
local prometheus = import '../../../../lib/prometheus.jsonnet';

local groupConfig = [
  {
    name: 'shoreline.rules',
    rules: [
      {
        alert: 'TidepoolShorelineMarketoConfigInvalid',
        annotations: {
          message: 'Marketo config is invalid for the pod: {{ $labels.job }} in the namespace: {{ $labels.namespace }}.',
        },
        expr: 'sum(tidepool_shoreline_marketo_config_valid) by (namespace)  == 0',
        'for': '1m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'tidepool-shoreline', groupConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name != 'shared'
  then [
    prometheusRule(me),
  ]
  else {}
)
