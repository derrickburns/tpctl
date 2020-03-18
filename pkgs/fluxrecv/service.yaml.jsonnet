local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace, pkg) {
  local me = config.namespaces[namespace].fluxrecv,
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'fluxrecv',
    namespace: namespace,
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
}
