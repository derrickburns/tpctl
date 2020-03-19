local lib = import '../../lib/lib.jsonnet';

local secret(config, me) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: lib.getElse(me, 'secret', 'thanos-objstore-config'),
    namespace: me.namespace,
  },
  data: {
    'thanos.yaml': std.base64(std.manifestYamlDoc({
      type: 'S3',
      config: {
        bucket: lib.getElse(me, 'bucket', 'tidepool-thanos'),
        endpoint: 's3.%s.amazonaws.com' % config.cluster.metadata.region,
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
      },
    })),
  },
};

function(config, prev, namespace, pkg)
  if lib.isEnabledAt(config, 'pkgs.prometheus')
  then secret(config, lib.package(config, namespace, pkg))
  else {}
