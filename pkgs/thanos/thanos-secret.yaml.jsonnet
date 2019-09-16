local secret(config) = {
  apiVersion: 'v1',
  kind: 'Secret',
  metadata: {
    name: config.pkgs.thanos.secret,
    namespace: 'monitoring',
  },
  data: {
    'thanos.yaml': std.manifestYamlDoc({
      type: 'S3',
      conf: {
        bucket: config.pkgs.thanos.bucket,
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
    }),
  },
};

function(config) secret(config)
