local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(me) = k8s.secret(me) {
  local config = me.config,
  stringData: {
    'object-store.yaml': std.manifestYamlDoc({
      type: 'S3',
      config: {
        bucket: lib.getElse(me, 'prometheus.thanos.sidecar.bucket', 'tidepool-thanos'),
        endpoint: 's3.%s.amazonaws.com' % config.cluster.metadata.region,
        region: config.cluster.metadata.region,
        put_user_metadata: {},
        http_config: {
          idle_conn_timeout: '1m30s',
          response_header_timeout: '2m',
          insecure_skip_verify: false,
        },
        trace: {
          enable: false,  // XXX
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
