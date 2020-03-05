local clusterrolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    labels: {
      app: 'prometheus',
    },
    name: 'prometheus',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'prometheus',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'prometheus',
      namespace: namespace,
    },
  ],
};

function(config, prev, namespace) clusterrolebinding(namespace)
