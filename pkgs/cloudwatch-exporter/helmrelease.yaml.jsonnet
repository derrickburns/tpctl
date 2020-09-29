local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'prometheus-cloudwatch-exporter', version: '0.9.0', repository: 'https://prometheus-community.github.io/helm-charts' }) {
  spec+: {
    chart+: {
      name: 'prometheus-cloudwatch-exporter',
    },
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      config: std.manifestYamlDoc({
        region: me.config.cluster.metadata.region,
        metrics: [
          {
            aws_namespace: 'AWS/SES',
            aws_metric_name: 'Reputation.ComplaintRate',
            aws_statistics: ['Sum'],
            set_timestamp: false,
            period_seconds: 3600,
            range_seconds: 3600,
          },
          {
            aws_namespace: 'AWS/SES',
            aws_metric_name: 'Reputation.BounceRate',
            aws_statistics: ['Sum'],
            set_timestamp: false,
            period_seconds: 3600,
            range_seconds: 3600,
          },
        ],
      },),
      securityContext: {
        fsGroup: 65534,
      },
      serviceAccount: {
        name: me.pkg,
        create: false,
      },
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'prometheus-operator'),
        interval: '2m',
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
