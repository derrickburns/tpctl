local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'kafka-minion', version: '1.3.1', repository: 'https://raw.githubusercontent.com/adinhodovic/kafka-minion-helm-chart/release' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      kafka: {
        brokers: std.join(',', me.brokers),
        tls: {
          enabled: true,
        },
      },
      serviceMonitor: {
        create: global.isEnabled(me.config, 'kube-prometheus-stack'),
        interval: '10s',
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
