local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '1.1.11', repository: 'https://kubernetes-charts.storage.googleapis.com' } ) {
  spec+: {

  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
