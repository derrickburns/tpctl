local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'kubernetes-dashboard',
    namespace: 'kubernetes-dashboard',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'cluster-admin',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'kubernetes-dashboard',
      namespace: namespace,
    },
  ],
};

function(config, prev, namespace) clusterrolebinding(namespace)