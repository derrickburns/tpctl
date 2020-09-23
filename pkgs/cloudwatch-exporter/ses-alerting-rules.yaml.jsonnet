local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local prometheus = import '../../lib/prometheus.jsonnet';

local groupConfig(me) = [
  {
    name: 'ses.rules',
    rules: [
      {
        alert: 'SesBounceRateHigh',
        annotations: {
          summary: 'SES bounce rate is too high.',
          description: 'SES bounce rate is above 5%.',
          dashboard_url: 'https://grafana.%s/d/WojOgXTmkf2f/aws-ses?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
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
          summary: 'SES complaint rate is too high.',
          description: 'SES complaint rate is above 5%.',
          dashboard_url: 'https://grafana.%s/d/WojOgXTmkf2f/aws-ses?orgId=1&refresh=10s' % me.config.cluster.metadata.domain,
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

local prometheusRule(me) = prometheus.prometheusRule(me, 'aws-ses', groupConfig(me));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.getElse(me, 'opsMonitoring', false)
  then [
    prometheusRule(me),
  ]
  else {}
)
