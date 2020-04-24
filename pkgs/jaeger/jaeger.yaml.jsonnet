local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local common = import '../../lib/common.jsonnet';

local jaeger(me) = k8s.k( 'jaegertracing.io/v1', 'Jaeger') + k8s.metadata('jaeger', me.namespace) {
  spec+: {
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
          //'server-urls': 'https://jaeger-es-http.%s:9200' % me.namespace,
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

function(config, prev, namespace, pkg) jaeger(common.package(config, prev, namespace, pkg))
