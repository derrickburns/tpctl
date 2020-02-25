local lib = import '../../lib/lib.jsonnet';

function(config, prev, namespace) {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'mongoproxy',
    namespace: namespace,
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
      name: 'mongoproxy',
    },
  },
}
