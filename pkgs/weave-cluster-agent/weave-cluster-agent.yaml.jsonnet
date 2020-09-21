local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
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
        'pods/log',
        'services',
        'nodes',
        'namespaces',
        'persistentvolumes',
        'persistentvolumeclaims',
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
        'daemonsets',
        'statefulsets',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'batch',
      ],
      resources: [
        'cronjobs',
        'jobs',
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
        'daemonsets',
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
        'deployments/scale',
      ],
      verbs: [
        'get',
        'update',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'deployments/scale',
      ],
      verbs: [
        'get',
        'update',
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
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'volumesnapshot.external-storage.k8s.io',
      ],
      resources: [
        'volumesnapshots',
        'volumesnapshotdatas',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
  ],
};

local deployment(me) = k8s.deployment(
  me,
  serviceAccount=true,
  containers={
    args: [
      '--mode=probe',
      '--probe-only',
      '--probe.kubernetes.role=cluster',
      '--probe.http.listen=:4041',
      '--probe.publish.interval=4500ms',
      '--probe.spy.interval=2s',
      'weave-scope-app.%s.svc.cluster.local:80' % me.namespace,
    ],
    command: [
      '/home/weave/scope',
    ],
    env: [],
    image: 'docker.io/weaveworks/scope:1.13.0',
    ports: [
      {
        containerPort: 4041,
        protocol: 'TCP',
      },
    ],
    resources: {
      requests: {
        cpu: '25m',
        memory: '80Mi',
      },
    },
  },
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);

  [
    deployment(me),
    clusterrole(me),
    k8s.serviceaccount(me),
    k8s.clusterrolebinding(me),
  ]
)
