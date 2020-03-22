local lib = import '../../lib/lib.jsonnet';

local service(me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      app: me.pkg,
    },
    name: me.pkg,
    namespace: me.namespace,
  },
  spec: {
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
