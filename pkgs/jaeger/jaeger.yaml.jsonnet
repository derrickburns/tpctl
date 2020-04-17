local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';

local jaeger(config, namespace) = {
  apiVersion: 'jaegertracing.io/v1',
  kind: 'Jaeger',
  metadata: {
    name: 'jaeger',
    namespace: namespace,
  },
  spec: {
    strategy: 'production',
    ingress: {
      enabled: false,
    },
    storage: {
      type: "memory",
      options: {
        memory: {
          'max-traces': 100000,
        },
      },
      //type: 'elasticsearch',
      //options: {
        //es: {
          //'server-urls': 'https://jaeger-es-http.%s:9200' % namespace,
          //tls: {
            //ca: '/es/certificates/ca.crt',
          //},
        //},
      //},
      esIndexCleaner: {
        enabled: false,
      },
      secretName: 'jaeger-secret',
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

function(config, prev, namespace, pkg) jaeger(config, namespace)
