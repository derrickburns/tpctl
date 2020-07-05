local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local externalname(me) = k8s.service(me, type='ExternalName') {
  metadata+: {
    name: me.pkg,
    namespace: lib.getElse( me 'expose.namespace', 'global'),
  },
  spec+: {
    externalName: me.target.name,
    ports: [
      {
        port: lib.getElse(me, 'expose.port', me.target.port),
        protocol: 'TCP',
        targetPort: me.target.port,
      },
    ],
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  externalname(me)
)
