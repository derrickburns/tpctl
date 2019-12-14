local lib = import "../../lib/lib.jsonnet";

local serviceMonitor(config) = {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        labels: {
          release: 'monitoring-prometheus-operator',
        },
        name: 'gloo-servicemonitor',
        namespace: 'gloo-system',
      },
      spec: {
        endpoints: [
          {
            path: '/metrics',
            port: 'metrics',
          },
        ],
        jobLabel: 'gloo',
        namespaceSelector: {
          matchNames: [
            'gloo-system',
          ],
        },
        selector: {
          matchLabels: {
            'gateway-proxy': 'live',
            'gateway-proxy-id': 'gateway-proxy',
          },
        },
      },
};

function(config,prev) 
 if lib.getElse(config, 'pkgs.prometheus-operator.enabled', false)
 then serviceMonitor(config)
 else {}

