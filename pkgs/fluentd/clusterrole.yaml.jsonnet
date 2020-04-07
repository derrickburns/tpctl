local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
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
