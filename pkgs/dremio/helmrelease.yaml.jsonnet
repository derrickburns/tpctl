local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'charts/dremio_v2', git: 'git@github.com:dremio/dremio-cloud-tools.git' }) {
  spec+: {
    values+: {
      zookeeper: {
        name: 'zookeeper-client.%s.svc.cluster.local' % me.namespace,
      },
      imageTag: '4.8.0',
      serviceType: 'ClusterIP',
      storageClass: 'gp2-expanding',
      coordinator: {
        cpu: 2,
        memory: 20000,
      },
      executor: {
        cpu: 3,
        memory: 30000,
        count: 1,
      },
      affinity: {
        nodeAffinity: k8s.nodeAffinity(values='analytics'),
      },
      tolerations: [k8s.toleration(value='analytics')],
    } + lib.getElse(me, 'chartValues', {}),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
