local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local secretName = 'sumologic';

local helmrelease(me) = k8s.helmrelease(me, {
  name: 'sumologic-fluentd',
  repository: 'https://sumologic.github.io/sumologic-kubernetes-collection',
  version: '0.13.0',
}, secretNames=[secretName]) {
  local config = me.config,

  metadata: {
    name: 'sumologic-fluentd',
  },
  spec: {
    'kube-prometheus-stack': {
      prometheus: {
        prometheusSpec: {
          externalLabels: {
            cluster: config.cluster.metadata.name,
          },
        },
      },
      enabled: false,
    },

    clusterName: config.cluster.metadata.name,

    image: {
      pullPolicy: 'IfNotPresent',
      repository: 'sumologic/kubernetes-fluentd',
      tag: '0.13.0',
    },
    sumologic: {
      envFromSecret: secretName,
      excludeNamespaceRegex: std.join('|', lib.namespacesWithout(config, 'logging', false)),
      readFromHead: false,
      sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,

    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
