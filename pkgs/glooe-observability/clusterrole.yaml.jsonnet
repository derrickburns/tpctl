local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        'gloo.solo.io',
      ],
      resources: [
        'upstreams',
        'settings',
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
