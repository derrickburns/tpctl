local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, {
  name: 'sumologic-fluentd',
  repository: 'https://sumologic.github.io/sumologic-kubernetes-collection',
  version: '0.13.0',
}) {
  _secretNames:: ['sumologic'],

  metadata: {
    name: 'sumologic-fluentd',
  },
  spec: {
    'prometheus-operator': {
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
      envFromSecret: $._secretNames[0],
      excludeNamespaceRegex: std.join('|', lib.namespacesWithout(config, 'logging', false)),
      readFromHead: false,
      sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,

    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, common.package(config, prev, namespace, pkg))
