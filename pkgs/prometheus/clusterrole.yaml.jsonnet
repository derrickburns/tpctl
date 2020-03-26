local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = {
  apiVersion: 'rbac.authorization.k8s.io/v1',
  kind: 'ClusterRole',
  metadata: {
    labels: {
      app: me.pkg,
    },
    name: me.pkg,
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

function(config, prev, namespace, pkg) clusterrole(lib.package(config, namespace, pkg))
