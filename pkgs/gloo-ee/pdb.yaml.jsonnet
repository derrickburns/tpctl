local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local pdb(me, selector) = k8s.pdb(me) {
  spec+: {
    selector: selector,
  },
};

local add_pdb(me, selector, enabled) = (
  if enabled == true
  then pdb(me, selector)
  else {}
);

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    add_pdb(me, { gloo: 'gloo' }, lib.isEnabledAt(me, 'pdb')),
    add_pdb(me, { gloo: 'gloo' }, lib.isEnabledAt(me, 'pdb')),
    add_pdb(me, { gloo: 'gloo' }, lib.isEnabledAt(me, 'pdb')),
  ]
)
