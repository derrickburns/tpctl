{
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'strimzi',
    },
    name: 'strimzi-cluster-operator-namespaced',
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'serviceaccounts',
      ],
      verbs: [
        'get',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'rbac.authorization.k8s.io',
      ],
      resources: [
        'rolebindings',
      ],
      verbs: [
        'get',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'configmaps',
        'services',
        'secrets',
        'persistentvolumeclaims',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'kafka.strimzi.io',
      ],
      resources: [
        'kafkas',
        'kafkas/status',
        'kafkaconnects',
        'kafkaconnects/status',
        'kafkaconnects2is',
        'kafkaconnects2is/status',
        'kafkaconnectors',
        'kafkaconnectors/status',
        'kafkamirrormakers',
        'kafkamirrormakers/status',
        'kafkabridges',
        'kafkabridges/status',
        'kafkamirrormaker2s',
        'kafkamirrormaker2s/status',
        'kafkarebalances',
        'kafkarebalances/status',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'pods',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'delete',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'endpoints',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'deployments',
        'deployments/scale',
        'replicasets',
        'replicationcontrollers',
        'networkpolicies',
        'ingresses',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'deployments',
        'deployments/scale',
        'deployments/status',
        'statefulsets',
        'replicasets',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
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
        'apps.openshift.io',
      ],
      resources: [
        'deploymentconfigs',
        'deploymentconfigs/scale',
        'deploymentconfigs/status',
        'deploymentconfigs/finalizers',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'build.openshift.io',
      ],
      resources: [
        'buildconfigs',
        'builds',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'watch',
        'update',
      ],
    },
    {
      apiGroups: [
        'image.openshift.io',
      ],
      resources: [
        'imagestreams',
        'imagestreams/status',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'watch',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'networking.k8s.io',
      ],
      resources: [
        'networkpolicies',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'route.openshift.io',
      ],
      resources: [
        'routes',
        'routes/custom-host',
      ],
      verbs: [
        'get',
        'list',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
    {
      apiGroups: [
        'policy',
      ],
      resources: [
        'poddisruptionbudgets',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'delete',
        'patch',
        'update',
      ],
    },
  ],
}
