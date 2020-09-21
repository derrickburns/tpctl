local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local containerPort = 8080;

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

local deployment(me) = k8s.deployment(me,
                                      serviceAccount=true,
                                      containers={
                                        image: 'quay.io/coreos/kube-state-metrics:v1.8.0',
                                        ports: [
                                          {
                                            containerPort: containerPort,
                                            name: 'metrics',
                                          },
                                        ],
                                      }) {
  spec+: {
    template+: {
      spec: {
        securityContext: {
          runAsNonRoot: true,
          runAsUser: 65534,
        },
      },
    },
  },
};

local service(me) = k8s.service(me) {
  spec+: {
    ports: [k8s.port(80, containerPort)],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    service(me),
    deployment(me),
    k8s.clusterrolebinding(me),
    clusterrole(me),
  ]
)
