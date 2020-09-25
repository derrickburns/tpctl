{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-kafka-broker',
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'nodes',
      ],
      verbs: [
        'get',
      ],
    },
  ],
}
