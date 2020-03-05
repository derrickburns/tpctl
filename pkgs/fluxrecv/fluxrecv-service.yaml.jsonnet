local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace) {
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
      name: if lib.getElse(config.namespaces[namespace], 'fluxrecv.sidecar', false) then 'flux' else 'fluxrecv',
    },
  },
}
