local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local service(me) = k8s.service(me.pkg, me.namespace) {
  spec+: {
    ports: [
      {
        name: 'http',
        port: 3000,
        targetPort: 3000,
      },
    ],
    selector: {
      app: me.pkg,
    },
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
