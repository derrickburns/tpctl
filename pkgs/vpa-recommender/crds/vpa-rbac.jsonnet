{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    name: 'system:metrics-reader',
  },
  rules: [
    {
      apiGroups: [
        'metrics.k8s.io',
      ],
      resources: [
        'pods',
      ],
      verbs: [
        'get',
        'list',
      ],
    },
  ],
}
