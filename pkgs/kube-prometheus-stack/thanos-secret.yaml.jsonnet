local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(me) = k8s.secret(me) {
  local config = me.config,
  metadata+: {
    labels: {
      app: 'thanos',
    },
    name: 'thanos',
  },

  stringData: {
    'object-store.yaml': std.manifestYamlDoc({
      type: 'S3',
      config: {
        bucket: lib.getElse(me, 'prometheus.thanos.sidecar.bucket', 'tidepool-thanos'),
        endpoint: 's3.%s.amazonaws.com' % config.cluster.metadata.region,
        region: config.cluster.metadata.region,
        encryptsse: true,
        put_user_metadata: {},
        trace: {
          enable: true,  // XXX
        },
      },
    }),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.getElse(me, 'prometheus.thanos.sidecar.enabled', false)
  then [
    secret(me),
  ]
  else {}
)
