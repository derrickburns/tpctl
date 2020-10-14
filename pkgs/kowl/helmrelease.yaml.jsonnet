local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'kowl', version: '1.1.0', repository: 'https://raw.githubusercontent.com/cloudhut/charts/master/archives' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      secret: lib.getElse(me, 'secret', {}),
      kowl: {
        config: {
          kafka: {
            brokers: me.brokers,
            sasl: lib.getElse(me, 'sasl', {}),
            tls: {
              enabled: lib.isEnabledAt(me, 'tls'),
            },
          },
        },
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
