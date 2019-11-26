local lib = import '../../lib/lib.jsonnet';

function(config, prev) {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: "fluxrecv",
    namespace: lib.namespace(config, "flux"),
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
      "name": "flux",
    },
  },
}
