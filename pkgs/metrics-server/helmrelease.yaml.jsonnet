local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '2.10.0' }) {
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
};

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))
