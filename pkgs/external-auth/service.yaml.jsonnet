local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local service(me) = k8s.service(me.pkg, me.namespace) {
  spec+: {
    selector: {
      app: me.pkg,
    },
    ports: [{
      name: 'http',
      protocol: 'TCP',
      port: 8080,
      targetPort: 4000,
    }],
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
