local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'system:aggregated-metrics-reader:metrics-server',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'system:aggregated-metrics-reader',
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
