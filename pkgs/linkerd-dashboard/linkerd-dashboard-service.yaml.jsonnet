local lib = import '../../lib/lib.jsonnet';

function(config, prev) {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: pkg,
    namespace: lib.namespace(config, pkg),
  },
  spec: {
    type: 'ClusterIP',
    ports: [{
      name: 'http',
      protocol: 'TCP',
      port: 8080,
      targetPort: 8084,
    }],
    selector: {
      "linkerd.io/control-plane-component": "web",
      "linkerd.io/control-plane-ns": "linkerd",
      "linkerd.io/proxy-deployment": "linkerd-web",
    },
  },
}