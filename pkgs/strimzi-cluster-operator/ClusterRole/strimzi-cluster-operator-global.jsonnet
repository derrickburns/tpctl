{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-cluster-operator-global',
  },
  rules: [
    {
      apiGroups: [
        'rbac.authorization.k8s.io',
      ],
      resources: [
        'clusterrolebindings',
      ],
      verbs: [
        'get',
        'create',
        'delete',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'storage.k8s.io',
      ],
      resources: [
        'storageclasses',
      ],
      verbs: [
        'get',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'nodes',
      ],
      verbs: [
        'list',
      ],
    },
  ],
}
