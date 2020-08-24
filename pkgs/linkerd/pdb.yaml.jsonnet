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
        'linkerd.io/control-plane-component': 'controller',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-controller'),
    add_pdb(me, {
      matchLabels: {
        'linkerd.io/control-plane-component': 'destination',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-destination'),
    add_pdb(me, {
      matchLabels: {
        'linkerd.io/control-plane-component': 'identity',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-identity'),
    add_pdb(me, {
      matchLabels: {
        'linkerd.io/control-plane-component': 'proxy-injector',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-proxy-injector'),
    add_pdb(me, {
      matchLabels: {
        'linkerd.io/control-plane-component': 'sp-validator',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-sp-validator'),
    add_pdb(me, {
      matchLabels: {
        'linkerd.io/control-plane-component': 'linkerd-tap',
      },
    }, lib.isEnabledAt(me, 'pdb'), 'linkerd-tap'),
  ]
)
