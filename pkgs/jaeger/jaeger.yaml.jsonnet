local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local jaeger(me) = k8s.k('jaegertracing.io/v1', 'Jaeger') + k8s.metadata('jaeger', me.namespace) {
  spec+: {
    strategy: 'production',
    ingress: {
      enabled: false,
    },
    storage: {
      type: 'elasticsearch',
      options: {
        es: {
          'server-urls': 'https://elasticsearch-master:9200',
          tls: {
            'skip-host-verify': true,
          },
          secretName: 'elastic-credentials',
        },
      },
    },
    affinity: {
      nodeAffinity: k8s.nodeAffinity(),
    },
    tolerations: [k8s.toleration()],
  },
};

function(config, prev, namespace, pkg) jaeger(common.package(config, prev, namespace, pkg))
