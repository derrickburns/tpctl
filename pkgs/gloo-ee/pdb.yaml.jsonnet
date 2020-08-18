local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local pdb(me, selector, name) = k8s.pdb(me) {
  metadata+: {
    name: name,
  },
  spec+: {
    selector: selector,
  },
};

local add_pdb(me, selector, enabled, name) = (
  if enabled == true
  then pdb(me, selector, name)
  else {}
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    add_pdb(me, {
      matchLabels: {
        gloo: 'gloo',
      },
    }, lib.isEnabledAt(me, 'gloo.pdb'), 'gloo'),
    add_pdb(me, {
      matchLabels: {
        'gateway-proxy-id': 'gateway-proxy',
      },
    }, lib.isEnabledAt(me, 'proxies.gatewayProxy.pdb'), 'gateway-proxy'),
    add_pdb(me, {
      matchLabels: {
        'gateway-proxy-id': 'internal-gateway-proxy',
      },
    }, lib.isEnabledAt(me, 'proxies.internalGatewayProxy.pdb'), 'internal-gateway-proxy'),
    add_pdb(me, {
      matchLabels: {
        'gateway-proxy-id': 'pomerium-gateway-proxy',
      },
    }, lib.isEnabledAt(me, 'proxies.pomeriumGatewayProxy.pdb'), 'pomerium-gateway-proxy'),
  ]
)
