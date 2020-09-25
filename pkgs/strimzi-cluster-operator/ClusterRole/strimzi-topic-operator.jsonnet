{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-topic-operator',
  },
  rules: [
    {
      apiGroups: [
        'kafka.strimzi.io',
      ],
      resources: [
        'kafkatopics',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'patch',
        'update',
        'delete',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'events',
      ],
      verbs: [
        'create',
      ],
    },
  ],
}
