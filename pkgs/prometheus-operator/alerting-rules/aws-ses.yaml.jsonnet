local common = import '../../../lib/common.jsonnet';
local prometheus = import '../../../lib/prometheus.jsonnet';

local groupConfig = [
  {
    name: 'ses.rules',
    rules: [
      {
        alert: 'SesBounceRateHigh',
        annotations: {
          message: 'SES bounce rate is above 5%',
        },
        expr: 'aws_ses_reputation_bounce_rate_sum > 0.05',
        'for': '10m',
        labels: {
          severity: 'critical',
        },
      },
      {
        alert: 'SesComplaintRateHigh',
        annotations: {
          message: 'SES complaint rate is above 5%',
        },
        expr: 'aws_ses_reputation_complaint_rate_sum > 0.05',
        'for': '10m',
        labels: {
          severity: 'critical',
        },
      },
    ],
  },
];

local prometheusRule(me) = prometheus.prometheusRule(me, 'aws-ses', groupConfig);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if me.config.cluster.metadata.name == 'shared'
  then [
    prometheusRule(me),
  ]
  else {}
)
