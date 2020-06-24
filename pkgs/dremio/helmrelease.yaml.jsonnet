local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: lib.getElse(me, 'version', '0.2.0'), repository: 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master/' }) {
  spec+: {
    values+: {
      distStorage: {
        type: "aws",
        aws: {
          bucketName: "tidepool-%s" % me.pkg,
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
