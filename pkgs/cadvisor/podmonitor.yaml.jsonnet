local lib = import "../../lib/lib.jsonnet";

local podmonitor(config) = {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PodMonitor',
  metadata: {
    name: 'cadvisor',
    namespace: 'cadvisor',
  },
  spec: {
    jobLabel: 'kubernetes-cadvisor', // ????
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

function(config, prev) 
  if lib.getElse(config, 'pkgs.prometheus-operator.enabled', false)
  then podmonitor(config)
  else {}