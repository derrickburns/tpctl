local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.9.1', repository: 'https://jupyterhub.github.io/helm-chart' } ) {
  spec+: {

  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
