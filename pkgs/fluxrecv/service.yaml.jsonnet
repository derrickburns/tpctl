local lib = import '../../lib/lib.jsonnet';

local service(config, me) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'fluxrecv',
    namespace: me.namespace,
  },
  spec: {
    type: 'ClusterIP',
    ports: [{
      name: 'http',
      protocol: 'TCP',
      port: 8080,
      targetPort: 8080,
    }],
    selector: {
      name: if lib.isTrue(me, 'sidecar') then 'flux' else 'fluxrecv',
    },
  },
};

function(config, prev, namespace, pkg) service(config, lib.package(config, namespace, pkg))
