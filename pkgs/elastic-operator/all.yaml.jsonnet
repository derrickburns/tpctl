local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local statefulset(me) = k8s.statefulset(me) {
  spec+: {
    template+: {
      spec+: {
        containers: [
          {
            args: [
              'manager',
              '--operator-roles',
              'all',
              '--enable-debug-logs=false',
            ],
            env: [
              k8s.envField('OPERATOR_NAMESPACE', 'metadata.namespace'),
              k8s.envValue('WEBHOOK_SECRET', 'webhook-server-secret'),
              k8s.envValue('WEBHOOK_PODS_LABEL', me.pkg),
              k8s.envValue('OPERATOR_IMAGE', 'docker.elastic.co/eck/eck-operator:1.0.0-beta1'),
            ],
            image: 'docker.elastic.co/eck/eck-operator:1.0.0-beta1',
            name: me.pkg,
            ports: [
              {
                containerPort: 9876,
                name: 'webhook-server',
                protocol: 'TCP',
              },
            ],
            resources: {
              limits: {
                cpu: 1,
                memory: '150Mi',
              },
              requests: {
                cpu: '100m',
                memory: '50Mi',
              },
            },
          },
        ],
        serviceAccountName: me.pkg,
        terminationGracePeriodSeconds: 10,
      },
    },
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
        'endpoints',
        'events',
        'persistentvolumeclaims',
        'secrets',
        'services',
        'configmaps',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'apps',
      ],
      resources: [
        'deployments',
        'statefulsets',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'batch',
      ],
      resources: [
        'cronjobs',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
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
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'elasticsearch.k8s.elastic.co',
      ],
      resources: [
        'elasticsearches',
        'elasticsearches/status',
        'elasticsearches/finalizers',
        'enterpriselicenses',
        'enterpriselicenses/status',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'kibana.k8s.elastic.co',
      ],
      resources: [
        'kibanas',
        'kibanas/status',
        'kibanas/finalizers',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'apm.k8s.elastic.co',
      ],
      resources: [
        'apmservers',
        'apmservers/status',
        'apmservers/finalizers',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'associations.k8s.elastic.co',
      ],
      resources: [
        'apmserverelasticsearchassociations',
        'apmserverelasticsearchassociations/status',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
    {
      apiGroups: [
        'admissionregistration.k8s.io',
      ],
      resources: [
        'mutatingwebhookconfigurations',
        'validatingwebhookconfigurations',
      ],
      verbs: [
        'get',
        'list',
        'watch',
        'create',
        'update',
        'patch',
        'delete',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.clusterrolebinding(me),
    k8s.serviceaccount(me),
    statefulset(me),
    clusterrole(me),
  ]
)

