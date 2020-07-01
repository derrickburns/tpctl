local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'prometheus-cloudwatch-exporter', version: lib.getElse(me, 'version', '0.8.1'), repository: 'https://kubernetes-charts.storage.googleapis.com' }) {
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
        region: 'us-west-2',
        metrics: [
          {
            aws_namespace: 'AWS/SES',
            aws_metric_name: 'Reputation.ComplaintRate',
            aws_statistics: ['Sum'],
            set_timestamp: false,
          },
          {
            aws_namespace: 'AWS/SES',
            aws_metric_name: 'Reputation.BounceRate',
            aws_statistics: ['Sum'],
            set_timestamp: false,
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
        enabled: true,
        interval: '10m',
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
