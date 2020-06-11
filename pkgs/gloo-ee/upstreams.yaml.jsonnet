local common = import '../../lib/common.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';

local upstream(me, name) = gloo.kubeupstream(me, port=80, name=name) {
  spec+: {
    kube+: {
      selector: {
        'gateway-proxy': 'live',
        'gateway-proxy-id': name,
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    upstream(me, name='internal-gateway-proxy') {
      spec+: {
        connectionConfig: {
          tcpKeepalive: {
            keepaliveTime: '150s'
          },
        },
      },
    },
    upstream(me, name='gateway-proxy'),
    upstream(me, name='pomerium-gateway-proxy'),
  ]
)
