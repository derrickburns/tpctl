local lib = import '../../lib/lib.jsonnet';

local servicemonitor(namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    annotations: null,
    labels: {
      'k8s-app': 'linkerd-prometheus',
      release: 'monitoring-prometheus-operator',
    },
    name: 'linkerd-federate',
    namespace: namespace,
  },
  spec: {
    endpoints: [
      {
        honorLabels: true,
        interval: '30s',
        params: {
          'match[]': [
            '{job="linkerd-proxy"}',
            '{job="linkerd-controller"}',
          ],
        },
        path: '/federate',
        port: 'admin-http',
        relabelings: [
          {
            action: 'keep',
            regex: '^prometheus$',
            sourceLabels: [
              '__meta_kubernetes_pod_container_name',
            ],
          },
        ],
        scrapeTimeout: '30s',
      },
    ],
    jobLabel: 'app',
    namespaceSelector: {
      matchNames: [
        namespace,
      ],
    },
    selector: {
      matchLabels: {
        'linkerd.io/control-plane-component': 'prometheus',
      },
    },
  },
};

function(config, prev, namespace, pkg) 
  if lib.isEnabledAt(config, 'pkgs.prometheusOperator')
  then servicemonitor(namespace)
  else {}
