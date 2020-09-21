local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secretName = 'sumologic';

local helmrelease(me) = k8s.helmrelease(me, { name: 'sumologic-fluentd', version: '1.1.1' }, secretNames=[secretName]) {
  spec+: {
    values: {
      rbac: {
        create: true,
      },
      sumologic: {
        collectorUrlExistingSecret: secretName,
        readFromHead: false,
        sourceCategoryPrefix: 'kubernetes/%s/' % me.config.cluster.metadata.name,
        excludeNamespaceRegex: std.join('|', common.namespacesWithout(me.config, 'logging', false)),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
