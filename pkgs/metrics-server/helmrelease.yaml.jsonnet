local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('metrics-server', namespace, '2.10.0') {
  spec+: {
    values: {
      args: [
          '--v=2',
          '--metric-resolution=30s',
          '--kubelet-insecure-tls',
          '--kubelet-preferred-address-types=InternalIP,Hostname,InternalDNS,ExternalDNS,ExternalIP',
        ],
      },
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
