local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '0.5.5', repository: 'https://raw.githubusercontent.com/timescale/timescaledb-kubernetes/master/charts/repo' }) {
  spec+: {
    values: {
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))
