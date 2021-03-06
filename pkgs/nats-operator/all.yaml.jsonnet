local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local deployment(me) = k8s.deployment(me,
                                      containers={
                                        args: [
                                          'nats-operator',
                                          '--feature-gates=ClusterScoped=true',
                                        ],
                                        env: [
                                          {
                                            name: 'MY_POD_NAMESPACE',
                                            valueFrom: {
                                              fieldRef: {
                                                fieldPath: 'metadata.namespace',
                                              },
                                            },
                                          },
                                          {
                                            name: 'MY_POD_NAME',
                                            valueFrom: {
                                              fieldRef: {
                                                fieldPath: 'metadata.name',
                                              },
                                            },
                                          },
                                        ],
                                        image: 'connecteverything/nats-operator:0.7.2',
                                        imagePullPolicy: 'Always',
                                        name: 'nats-operator',
                                        ports: [
                                          {
                                            containerPort: 8080,
                                            name: 'readyz',
                                          },
                                        ],
                                        readinessProbe: {
                                          httpGet: {
                                            path: '/readyz',
                                            port: 'readyz',
                                          },
                                          initialDelaySeconds: 15,
                                          timeoutSeconds: 3,
                                        },
                                      },
                                      serviceAccount=true) {
};

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        'apiextensions.k8s.io',
      ],
      resources: [
        'customresourcedefinitions',
      ],
      verbs: [
        'get',
        'list',
        'create',
        'update',
        'watch',
      ],
    },
    {
      apiGroups: [
        'nats.io',
      ],
      resources: [
        'natsclusters',
        'natsserviceroles',
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
      ],
      verbs: [
        'create',
        'watch',
        'get',
        'patch',
        'update',
        'delete',
        'list',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'services',
      ],
      verbs: [
        'create',
        'watch',
        'get',
        'patch',
        'update',
        'delete',
        'list',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'secrets',
      ],
      verbs: [
        'create',
        'watch',
        'get',
        'update',
        'delete',
        'list',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resources: [
        'pods/exec',
        'pods/log',
        'serviceaccounts/token',
        'events',
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
        'namespaces',
        'serviceaccounts',
      ],
      verbs: [
        'list',
        'get',
        'watch',
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
        'create',
        'watch',
        'get',
        'update',
        'delete',
        'list',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.serviceaccount(me),
    k8s.clusterrolebinding(me),
    clusterrole(me),
    deployment(me),
  ]
)
