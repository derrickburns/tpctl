local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

// values: if global.isEnabled(me.config, 'vpa-recommender') then { installVPA: false}, else {installVPA: true},

local helmrelease(me) = k8s.helmrelease(me, { version: '2.2.3', repository: 'https://charts.fairwinds.com/stable' }) {
  spec+: {
    values: {
      installVPA: if global.isEnabled(me.config, 'vpa-recommender') then false else true,
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
