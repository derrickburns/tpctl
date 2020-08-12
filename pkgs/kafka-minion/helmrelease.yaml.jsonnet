local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'kafka-minion', version: lib.getElse(me, 'version', '1.3.0'), repository: 'https://raw.githubusercontent.com/cloudworkz/kafka-minion-helm-chart/master' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      kafka: {
        brokers: me.brokers,
        tls: {
          enabled: true,
        },
      },
      serviceMonitor: {
        enabled: true,
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
