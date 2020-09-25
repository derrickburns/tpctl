{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    name: 'networking-bug-workaround',
  },
  rules: [
    {
      apiGroups: [
        'policy',
      ],
      resources: [
        'podsecuritypolicies',
      ],
      verbs: [
        'use',
      ],
    },
  ],
}
