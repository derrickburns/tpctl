local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrolebinding(me) = k8s.clusterrolebinding(me) + k8s.metadata('auth-delegator') {
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'ClusterRole',
    name: 'system:auth-delegator',
  },
};

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
        'horizontalpodautoscalers',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
  ],
};

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            args: [
              'start',
            ],
            env: [
              k8s.envVar('WATCH_NAMESPACE', ''),
              k8s.envField('POD_NAME', 'metadata.name'),
              k8s.envField('POD_NAMESPACE', 'metadata.namespace'),
              k8s.envVar('OPERATOR_NAME', me.pkg),
            ],
            image: 'jaegertracing/jaeger-operator:1.17.0',
            imagePullPolicy: 'Always',
            name: me.pkg,
            ports: [
              {
                containerPort: 8383,
                name: 'metrics',
              },
            ],
          },
        ],
        serviceAccountName: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    deployment(me),
    clusterrole(me),
    clusterrolebinding(me),
    k8s.clusterrolebinding(me),
  ]
)
