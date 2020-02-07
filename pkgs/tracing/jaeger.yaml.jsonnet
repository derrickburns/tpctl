local lib = import '../../lib/lib.jsonnet';

local jaeger(config) = {
  apiVersion: 'jaegertracing.io/v1',
  kind: 'Jaeger',
  metadata: {
    name: 'jaeger',
    namespace: 'tracing',
  },
  spec: {
    strategy: 'production',
    ingress: {
      enabled: false,
    },
    storage: {
      options: {
        es: {
          'server-urls': 'https://jaeger-es-http.tracing:9200',
          tls: {
            ca: '/es/certificates/ca.crt',
          },
        },
      },
      esIndexCleaner: {
        enabled: false,
      },
      secretName: 'jaeger-secret',
      type: 'elasticsearch',
    },
    volumeMounts: [
      {
        mountPath: '/es/certificates/',
        name: 'certificates',
        readOnly: true,
      },
    ],
    volumes: [
      {
        name: 'certificates',
        secret: {
          secretName: 'jaeger-es-http-certs-public',
        },
      },
    ],
  },
};

function(config, prev)
  if lib.getElse(config, 'pkgs.tracing.enabled', false)
  then jaeger(config)
  else {}
