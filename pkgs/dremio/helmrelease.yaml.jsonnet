local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'charts/dremio_v2', git: 'https://raw.githubusercontent.com/dremio/dremio-cloud-tools/master' }) {
  spec+: {
    values+: {
      distStorage: {
        type: 'aws',
        aws: {
          bucketName: 'tidepool-dremio-%s' % me.config.cluster.metadata.name,
        },
      },
      zookeeper: {
        name: 'zookeeper-client.%s.svc.cluster.local' % me.namespace,
      },
      imageTag: '4.8.0',
      serviceType: 'ClusterIP',
      storageClass: 'gp2-expanding',
    } + lib.getElse(me, 'chartValues', {}),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
