local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1beta1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'fluentd-role-binding',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'fluentd-role',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'fluentd',
      namespace: namespace,
    },
  ],
};

function(config, prev, namespace) clusterrolebinding(namespace)
