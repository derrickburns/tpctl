local lib = import '../../lib/lib.jsonnet';

local service(config, me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    app: 'fluxcloud',
    namespace: me.namespace,
  },
  spec: {
    selector: {
      app: 'fluxcloud',
    },
    ports: [
      {
        protocol: 'TCP',
        port: 80,
        targetPort: 3032,
      },
    ],
  },
};

function(config, prev, namespace, pkg) service(config, lib.package(config, namespace, pkg))
