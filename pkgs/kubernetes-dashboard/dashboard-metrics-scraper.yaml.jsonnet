local service(namespace) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    labels: {
      'k8s-app': 'dashboard-metrics-scraper',
    },
    name: 'dashboard-metrics-scraper',
    namespace: namespace,
  },
  spec: {
    ports: [
      {
        port: 8000,
        targetPort: 8000,
      },
    ],
    selector: {
      'k8s-app': 'dashboard-metrics-scraper',
    },
  },
};

function(config, prev, namespace, pkg) service(namespace)
