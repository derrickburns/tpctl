local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'pods',
        'services',
        'endpoints',
        'persistentvolumeclaims',
        'events',
        'configmaps',
        'secrets',
        'serviceaccounts',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'deployments',
        'daemonsets',
        'replicasets',
        'statefulsets',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'monitoring.coreos.com',
      ],
      resources: [
        'servicemonitors',
      ],
      verbs: [
        'get',
        'create',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'replicasets',
        'deployments',
        'daemonsets',
        'statefulsets',
        'ingresses',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'batch',
      ],
      resources: [
        'jobs',
        'cronjobs',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'route.openshift.io',
      ],
      resources: [
        'routes',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'logging.openshift.io',
      ],
      resources: [
        'elasticsearches',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'jaegertracing.io',
      ],
      resources: [
        '*',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'rbac.authorization.k8s.io',
      ],
      resources: [
        'clusterrolebindings',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [
        'apps',
        'extensions',
      ],
      resourceNames: [
        'jaeger-operator',
      ],
      resources: [
        'deployments/finalizers',
      ],
      verbs: [
        'update',
      ],
    },
    {
      apiGroups: [
        'kafka.strimzi.io',
      ],
      resources: [
        'kafkas',
        'kafkausers',
      ],
      verbs: [
        '*',
      ],
    },
    {
      apiGroups: [ 
       'autoscaling',
      ],
      resources: [
        'horizontalpodautoscalers'
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) clusterrole(lib.package(config, namespace, pkg))
