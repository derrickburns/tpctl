local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.5.5', repository: 'https://raw.githubusercontent.com/timescale/timescaledb-kubernetes/master/charts/repo' }) {
  spec+: {
    values+: {
      persistentVolumes: {
        data: {
          size: lib.getElse(me, 'data-storage', '2Gi'),
        },
        wal: {
          size: lib.getElse(me, 'wal-storage', '1Gi'),
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
