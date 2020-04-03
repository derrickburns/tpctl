local global = import '../../lib/global.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secret(config, me) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: lib.getElse(me, 'secret', 'thanos'),
    namespace: me.namespace,
  },
  data: {
    'object-store.yaml': std.base64(std.manifestYamlDoc({
      type: 'S3',
      config: {
        bucket: lib.getElse(me, 'bucket', 'tidepool-thanos'),
        endpoint: 'https://s3.%s.amazonaws.com' % config.cluster.metadata.region,
        region: config.cluster.metadata.region,
        insecure: false,
        signature_version2: false,
        encrypt_sse: false,
        put_user_metadata: {},
        http_config: {
          idle_conn_timeout: '0s',
          response_header_timeout: '0s',
          insecure_skip_verify: false,
        },
        trace: {
          enable: false,  // XXX
        },
	part_size: 0,
      },
    })),
  },
};

function(config, prev, namespace, pkg)
  if global.isEnabled(config, 'prometheus')
  then secret(config, lib.package(config, namespace, pkg))
  else {}
