{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-cluster-operator',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'strimzi-cluster-operator-global',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'strimzi-cluster-operator',
      namespace: 'kafka',
    },
  ],
}
