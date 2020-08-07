local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.6.2', repository: 'https://raw.githubusercontent.com/timescale/timescaledb-kubernetes/master/charts/repo' }) {
  spec+: lib.merge({
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(values=['timescale']),
      },
      tolerations: [k8s.toleration(value='timescale')],
      persistentVolumes: {
        data: {
          size: lib.getElse(me, 'data_storage', '2Gi'),
        },
        wal: {
          size: lib.getElse(me, 'wal_storage', '1Gi'),
        },
      },
      patroni: {
        bootstrap: {
          bootstrap: {
            dcs: {
              synchronous_mode: true,
              postgresql: {
                parameters: {
                  max_wal_senders: lib.getElse(me, 'max_wal_senders', 1),
                  wal_keep_segments: lib.getElse(me, 'wal_keep_segments', 8),
                  synchronous_commit: 'remote_apply',
                },
              },
            },
          },
        },
      },
    },
  }, lib.getElse(me, 'spec', {})),
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
