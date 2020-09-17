local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: me.pkg, version: '0.1.9', 'https://gradiant.github.io/charts' }) {
  spec+: {
    values+: {
	persistence: {
          nameNode: {
            enabled: true,
            storageClass: 'gp2-expanding'
          },
          dataNode: {
            enabled: true,
            storageClass: 'gp2-expanding'
          },
        },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
