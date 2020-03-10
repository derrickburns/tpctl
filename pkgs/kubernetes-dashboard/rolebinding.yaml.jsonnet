local rolebinding(namespace) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'RoleBinding',
  metadata: {
    labels: {
      'k8s-app': 'kubernetes-dashboard',
    },
    name: 'kubernetes-dashboard',
    namespace: 'kubernetes-dashboard',
  },
  roleRef: {
    apiGroup: 'rbac.authorization.k8s.io',
    kind: 'Role',
    name: 'kubernetes-dashboard',
  },
  subjects: [
    {
      kind: 'ServiceAccount',
      name: 'kubernetes-dashboard',
      namespace: 'kubernetes-dashboard',
    },
  ],
};

function(config, prev, namespace) rolebinding(namespace)
