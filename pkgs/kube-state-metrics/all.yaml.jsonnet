local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'namespaces',
        'nodes',
        'pods',
        'services',
        'resourcequotas',
        'replicationcontrollers',
        'limitranges',
        'persistentvolumeclaims',
        'persistentvolumes',
        'endpoints',
        'secrets',
        'configmaps',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'daemonsets',
        'deployments',
        'ingresses',
        'replicasets',
      ],
      verbs: [
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'daemonsets',
        'deployments',
        'statefulsets',
        'replicasets',
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
        'list',
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
        'list',
        'watch',
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
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'certificates.k8s.io',
      ],
      resources: [
        'certificatesigningrequests',
      ],
      verbs: [
        'list',
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
        'list',
        'watch',
      ],
    },
  ],
};

local clusterrolebinding(me) = k8s.clusterrolebinding(me);

local deployment(me) = k8s.deployment(me) {
  spec+: {
    template+: {
      spec: {
        containers: [
          {
            image: 'quay.io/coreos/kube-state-metrics:v1.8.0',
            imagePullPolicy: 'IfNotPresent',
            name: me.pkg,
            ports: [
              {
                containerPort: 8080,
                name: 'metrics',
              },
            ],
          },
        ],
        securityContext: {
          runAsNonRoot: true,
          runAsUser: 65534,
        },
        serviceAccountName: me.pkg,
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(80, 8080)],
  },
};

local serviceaccount(me) = k8s.serviceaccount(me);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    serviceaccount(me),
    service(me),
    deployment(me),
    clusterrolebinding(me),
    clusterrole(me),
  ]
)
