local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: me.pkg, version: lib.getElse(me, 'version', '2.2.0'), repository: 'https://kubernetes.github.io/dashboard/' }) {
  spec+: {
    values+: {
      metricsScraper: {
        enabled: false,
      },
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      serviceAccount: {
        name: me.pkg,
      },
    },
  },
};

local clusterRoleBinding(me) = k8s.clusterrolebinding(me, roleName='cluster-admin', namespace=me.namespace) {};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    clusterRoleBinding(me),
    helmrelease(me),
  ]
)
