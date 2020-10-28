local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(me) = k8s.secret(me) {
  local config = me.config,
  local package = 'thanos-sidecar',
  metadata+: {
    labels: {
      app: package,
    },
    name: package,
  },

  stringData: {
    'object-store.yaml': std.manifestYamlDoc({
      type: 'S3',
      config: {
        bucket: lib.getElse(me, 'prometheus.thanos.sidecar.bucket', 'tidepool-thanos'),
        endpoint: 's3.%s.amazonaws.com' % config.cluster.metadata.region,
        region: config.cluster.metadata.region,
        sse_config: {
          type: 'SSE-S3',
        },
        put_user_metadata: {},
        trace: {
          enable: false,  // XXX
        },
      },
    }),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if lib.isEnabledAt(me, 'prometheus.thanos.sidecar')
  then [
    secret(me),
  ]
  else {}
)
