local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local excluded(config) = (
   local all = std.set(std.objectFields(config.namespaces));
   local on = std.set(std.filter(function(x) lib.getElse(config.namespaces[x], 'config.logging', false), all));
   std.setDiff(all, on)
);

local helmrelease(config, namespace) = k8s.helmrelease('sumologic-fluentd', namespace, '1.1.1') {
  spec+: {
    values: {
      rbac: {
        create: true,
      },
      sumologic: {
        collectorUrlExistingSecret: 'sumologic',
        readFromHead: false,
        sourceCategoryPrefix: 'kubernetes/%s/' % config.cluster.metadata.name,
        excludeNamespaceRegex: std.join('|', excluded(config)),  
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, namespace)
