local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '0.5.5', repository: 'https://raw.githubusercontent.com/timescale/timescaledb-kubernetes/master/charts/repo' });

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))
