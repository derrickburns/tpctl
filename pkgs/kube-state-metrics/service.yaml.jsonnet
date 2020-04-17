local service(namespace) = {
local common = import '../../lib/common.jsonnet';
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    annotations: {
      'prometheus.io/scrape': 'true',
    },
    labels: {
      app: 'glooe-prometheus',
      chart: 'prometheus-9.5.1',
      component: 'kube-state-metrics',
      heritage: 'Helm',
      release: 'glooe',
    },
    name: 'glooe-prometheus-kube-state-metrics',
    namespace: namespace,
  },
  spec: {
    clusterIP: 'None',
    ports: [
      {
        name: 'http',
        port: 80,
        protocol: 'TCP',
        targetPort: 8080,
      },
    ],
    selector: {
      app: 'glooe-prometheus',
      component: 'kube-state-metrics',
      release: 'glooe',
    },
    type: 'ClusterIP',
  },
};

function(config, prev, namespace, pkg) service(namespace)
