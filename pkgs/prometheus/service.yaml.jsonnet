local lib = import '../../lib/lib.jsonnet';

local service(me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
    ports: [
      {
        name: 'http',
        port: 8080,
        protocol: 'TCP',
        targetPort: 9090,
      },
    ],
    selector: {
      app: me.pkg,
    },
    type: 'ClusterIP',
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
