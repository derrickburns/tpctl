local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _serviceAccount:: true,
  _containers:: {
    command: [
      'zookeeper-operator',
    ],
    env: [
      {
        name: 'WATCH_NAMESPACE',
        value: '',
      },
      {
        name: 'POD_NAME',
        valueFrom: {
          fieldRef: {
            fieldPath: 'metadata.name',
          },
        },
      },
      {
        name: 'OPERATOR_NAME',
        value: 'zookeeper-operator',
      },
    ],
    image: 'pravega/zookeeper-operator:latest',
    ports: [
      {
        containerPort: 60000,
        name: 'metrics',
      },
    ],
  },
};

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        'zookeeper.pravega.io',
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
        'policy',
      ],
      resources: [
        'poddisruptionbudgets',
      ],
      verbs: [
        '*',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    deployment(me),
    k8s.serviceaccount(me),
    k8s.clusterrolebinding(me),
    clusterrole(me),
  ]
)
