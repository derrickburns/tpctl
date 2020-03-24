local lib = import '../../lib/lib.jsonnet';

local service(me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    type: 'ClusterIP',
    ports: [{
      name: 'http',
      protocol: 'TCP',
      port: 27017,
      targetPort: 27017,
    }],
    selector: {
      name: me.pkg,
    },
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
