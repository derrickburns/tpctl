local clusterrolebinding() = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    name: 'jaeger-operator',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'jaeger-operator',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'jaeger-operator',
      namespace: 'jaeger-operator',
    },
  ],
};

function(config, prev, namespace) clusterrolebinding()
