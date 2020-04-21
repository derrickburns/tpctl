local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'sumologic-fluentd', version: '1.1.1' }) {
  _secretNames:: ['sumologic'],
  spec+: {
    values: {
      rbac: {
        create: true,
      },
      sumologic: {
        collectorUrlExistingSecret: $._secretNames[0],
        readFromHead: false,
        sourceCategoryPrefix: 'kubernetes/%s/' % me.config.cluster.metadata.name,
        excludeNamespaceRegex: std.join('|', common.namespacesWithout(me.config, 'logging', false)),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
