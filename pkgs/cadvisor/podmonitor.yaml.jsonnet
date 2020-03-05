local lib = import '../../lib/lib.jsonnet';

local podmonitor(config, namespace) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    labels: {
      purpose: 'support',
    },
    name: 'cadvisor',
    namespace: namespace,
  },
  spec: {
    podMetricsEndpoints: [
      {
        interval: '5s',
        targetPort: 8080,
      },
    ],
    selector: {
      matchLabels: {
        name: 'cadvisor',
      },
    },
  },
};

function(config, prev, namespace)
  if lib.getElse(config, 'pkgs.prometheus.enabled', false)
  then podmonitor(config, namespace)
  else {}
