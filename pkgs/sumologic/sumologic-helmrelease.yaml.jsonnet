local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config) = k8s.helmrelease('sumologic-fluentd', 'sumologic', '1.1.1') {
  spec+: {
    values: {
      rbac: {
        create: true,
      },
      sumologic: {
        collectorUrlExistingSecret: 'sumologic',
        readFromHead: false,
        sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,
        excludeNamespaceRegex: 'amazon-cloudwatch|external-dns|external-secrets|flux|kube-.*|linkerd|monitoring|reloader|sumologic',
      },
    },
  },
};

function(config, prev) helmrelease(config)
