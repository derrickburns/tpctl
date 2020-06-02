local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local topic = function(me) function(definition) k8s.k('kafka.strimzi.io/v1beta1', 'KafkaTopic') + {
  metadata: {
    name: lib.get(definition, 'name'),
    namespace: me.namespace,
    labels: {
      'strimzi.io/cluster': me.pkg,
    },
  },
  spec: {
    partitions: lib.getElse(definition, 'partitions', 1),
    replicas: lib.getElse(definition, 'replicas', 1),
  },
};

local topics(me) = std.map(topic(me), lib.getElse(me, 'topics', []));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  topics(me)
)
