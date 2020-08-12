local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'kowl', version: lib.getElse(me, 'version', '1.1.0'), repository: 'https://raw.githubusercontent.com/cloudhut/charts/master/archives' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      kowl: {
        config: {
          kafka: {
            brokers: me.brokers,
            tls: {
              enabled: true,
              insecureSkipTlsVerify: true,
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
