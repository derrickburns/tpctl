local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local clusterrole(me) = k8s.clusterrole(me) {
  rules: [
    {
      apiGroups: [
        '',
      ],
      resources: [
        'pods',
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
        'services',
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
        'pods/log',
      ],
      verbs: [
        'get',
        'list',
      ],
    },
  ],
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    k8s.clusterrolebinding(me),
    clusterrole(me),
  ]
)
