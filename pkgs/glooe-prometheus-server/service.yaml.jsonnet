local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'server',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-server',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        name: 'http',
        port: 80,
        protocol: 'TCP',
        targetPort: 9090,
      },
    ],
    selector: {
      app: 'glooe-prometheus',
      component: 'server',
      release: 'glooe',
    },
    sessionAffinity: 'None',
    type: 'ClusterIP',
  },
};

function(config, prev, namespace, pkg) service(namespace)
