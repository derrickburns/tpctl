local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('sumologic-fluentd', me.namespace, '1.1.1') {
  spec+: {
    values: {
      rbac: {
        create: true,
      },
      sumologic: {
        collectorUrlExistingSecret: 'sumologic',
        readFromHead: false,
        sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,
        excludeNamespaceRegex: std.join('|', lib.namespacesWithout(config, 'logging', false)),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
