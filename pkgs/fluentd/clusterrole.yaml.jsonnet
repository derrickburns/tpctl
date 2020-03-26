local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = {
  apiVersion: 'rbac.authorization.k8s.io/v1beta1',
  kind: 'ClusterRole',
  metadata: {
    name: me.pkg,
  },
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'namespaces',
        'pods',
        'pods/logs',
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
