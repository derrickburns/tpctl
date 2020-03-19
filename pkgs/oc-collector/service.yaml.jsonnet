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
        name: 'opencensus',
        port: 55678,
        protocol: 'TCP',
        targetPort: 55678,
      },
      {
        name: 'zipkin',
        port: 9411,
        protocol: 'TCP',
        targetPort: 9411,
      },
      {
        name: 'metrics',
        port: 8888,
        protocol: 'TCP',
        targetPort: 8888,
      },
    ],
    selector: {
      app: me.pkg,
    },
  },
};

function(config, prev, namespace, pkg) service(lib.package(config, namespace, pkg))
