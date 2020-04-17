local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { git: 'git@github.com:tidepool-org/development', path: 'charts/mongo' }) {
  spec+: {
    values: {
      mongodb: {
        seed: false,
        persistent: false,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))
