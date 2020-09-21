local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'prometheus-postgres-exporter', version: '1.3.3', repository: 'https://prometheus-community.github.io/helm-charts' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      serviceMonitor: {
        enabled: true,
      },
      config: {
        datasourceSecret: {
          name: 'pg-exporter-ds',
          key: 'connection-string',
        },
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
