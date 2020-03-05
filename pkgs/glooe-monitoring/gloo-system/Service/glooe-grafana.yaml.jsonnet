local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      app: 'glooe-grafana',
      chart: 'grafana-4.0.1',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-grafana',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        name: 'service',
        port: 80,
        protocol: 'TCP',
        targetPort: 3000,
      },
    ],
    selector: {
      app: 'glooe-grafana',
      release: 'glooe',
    },
    type: 'ClusterIP',
  },
};

function(config, prev, namespace) service(namespace)
