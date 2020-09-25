{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-entity-operator',
  },
  rules: [
    {
      apiGroups: [
        'kafka.strimzi.io',
      ],
      resources: [
        'kafkatopics',
        'kafkatopics/status',
        'kafkausers',
        'kafkausers/status',
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
    {
      apiGroups: [
        '',
      ],
      resources: [
        'secrets',
      ],
      verbs: [
        'get',
        'list',
        'create',
        'patch',
        'update',
        'delete',
      ],
    },
  ],
}
