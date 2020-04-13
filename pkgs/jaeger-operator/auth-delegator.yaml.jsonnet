local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) k8s.clusterrolebinding(lib.package(config, namespace, pkg)) + k8s.metadata('auth-delegator') {
  roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: "system:auth-delegator",
  },
}