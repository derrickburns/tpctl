local lib = import "../../lib/lib.jsonnet";

local podMonitor(config) = {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'PodMonitor',
      metadata: {
        name: 'gloo-gateway-proxies',
        namespace: 'gloo-system',
      },
      spec: {
        podMetricsEndpoints: [
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
            gloo: 'gateway-proxy', 
          },
        },
      },
};

function(config,prev) 
 if lib.getElse(config, 'pkgs.prometheus.enabled', false)
 then podMonitor(config)
 else {}

