local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        'jaegertracing.io',
      ],
      resources: [
        '*',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'apps',
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
        '',
      ],
      resources: [
        'configmaps',
        'persistentvolumeclaims',
        'pods',
        'secrets',
        'serviceaccounts',
        'services',
        'services/finalizers',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'ingresses',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'networking.k8s.io',
      ],
      resources: [
        'ingresses',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'console.openshift.io',
      ],
      resources: [
        'consolelinks',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'autoscaling',
      ],
      resources: [
        'horizontalpodautoscalers',
      ],
      verbs: [
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'namespaces',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'deployments',
      ],
      verbs: [
        'get',
        'list',
        'patch',
        'update',
        'watch',
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
        'create',
        'delete',
        'get',
        'list',
        'patch',
        'update',
        'watch',
      ],
    },
  ],
};

local deployment(me) = k8s.deployment(
  me,
  containers={
    args: [
      'start',
    ],
    env: [
      k8s.envVar('WATCH_NAMESPACE', ''),
      k8s.envField('POD_NAME', 'metadata.name'),
      k8s.envField('POD_NAMESPACE', 'metadata.namespace'),
      k8s.envVar('OPERATOR_NAME', me.pkg),
    ],
    image: 'jaegertracing/jaeger-operator:1.19.0',
    imagePullPolicy: 'Always',
    name: me.pkg,
    ports: [
      {
        containerPort: 8383,
        name: 'metrics',
      },
    ],
  },
  serviceAccount=true
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    deployment(me),
    clusterrole(me),
    k8s.clusterrolebinding(me),
  ]
)
