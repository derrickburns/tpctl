local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local jaeger(me) = k8s.k('jaegertracing.io/v1', 'Jaeger') + k8s.metadata('jaeger', me.namespace) {
  spec+: {
    strategy: 'production',
    ingress: {
      enabled: false,
    },
    collector: {
      autoscale: false,
      maxReplicas: 2,
    },
    storage: {
      type: 'elasticsearch',
      secretName: 'elastic-credentials',
      esIndexCleaner: {
        enabled: true,
        numberOfDays: 7,
        schedule: '55 23 * * *',
      },
      options: {
        es: {
          'server-urls': 'http://elasticsearch-master:9200',
          tls: {
            'skip-host-verify': true,
          },
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
