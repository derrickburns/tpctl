local clusterrole = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: 'prometheus',
    },
    name: 'prometheus',
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'services',
        'pods',
        'endpoints',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
  ],
};

function(config, prev, namespace) clusterrole
