local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'nodes',
        'nodes/proxy',
        'nodes/metrics',
        'services',
        'endpoints',
        'pods',
        'ingresses',
        'configmaps',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
    {
      apiGroups: [
        'extensions',
      ],
      resources: [
        'ingresses/status',
        'ingresses',
      ],
      verbs: [
        'get',
        'list',
        'watch',
      ],
    },
    {
      nonResourceURLs: [
        '/metrics',
      ],
      verbs: [
        'get',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) clusterrole(lib.package(config, namespace, pkg))
