{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRoleBinding',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-cluster-operator-kafka-broker-delegation',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'strimzi-kafka-broker',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'strimzi-cluster-operator',
      namespace: 'kafka',
    },
  ],
}
