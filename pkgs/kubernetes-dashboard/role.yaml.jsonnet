local role(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'Role',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard',
    namespace: namespace,
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resourceNames: [
        'kubernetes-dashboard-key-holder',
        'kubernetes-dashboard-certs',
        'kubernetes-dashboard-csrf',
      ],
      resources: [
        'secrets',
      ],
      verbs: [
        'get',
        'update',
        'delete',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resourceNames: [
        'kubernetes-dashboard-settings',
      ],
      resources: [
        'configmaps',
      ],
      verbs: [
        'get',
        'update',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resourceNames: [
        'heapster',
        'dashboard-metrics-scraper',
      ],
      resources: [
        'services',
      ],
      verbs: [
        'proxy',
      ],
    },
    {
      apiGroups: [
        '',
      ],
      resourceNames: [
        'heapster',
        'http:heapster:',
        'https:heapster:',
        'dashboard-metrics-scraper',
        'http:dashboard-metrics-scraper',
      ],
      resources: [
        'services/proxy',
      ],
      verbs: [
        'get',
      ],
    },
  ],
};

function(config, prev, namespace) role(namespace)
