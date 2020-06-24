local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: lib.getElse(me, 'version', '0.3.0'), repository: 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master/' }) {
  spec+: {
    values+: {
      distStorage: {
        type: "aws",
        aws: {
  	  bucketName: 'tidepool-dremio-%s' % me.config.cluster.metadata.name,
        },
      },
      imageTag: '4.5',
      serviceType: "ClusterIP",
      storageClass: "gp2-expanding",
    } + lib.getElse(me, 'chartValues', {}),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
