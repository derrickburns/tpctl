local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'system:metrics-server',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'system:metrics-server',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'metrics-server',
      namespace: namespace,
    },
  ],
};

function(config, prev, namespace) clusterrolebinding(namespace)
