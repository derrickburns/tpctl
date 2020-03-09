local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'cloudwatch-agent-role-binding',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'cloudwatch-agent-role',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'cloudwatch-agent',
      namespace: namespace,
    },
  ],
};

function(config, prev, namespace) clusterrolebinding(namespace)

