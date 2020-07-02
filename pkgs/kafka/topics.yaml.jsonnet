local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local topic = function(me) function(name, definition) k8s.k('kafka.strimzi.io/v1beta1', 'KafkaTopic') + {
  metadata: {
    name: name,
    namespace: me.namespace,
    labels: {
      'strimzi.io/cluster': me.pkg,
    },
  },
  spec: lib.merge({
    partitions: 1,
    replicas: 1,
  }, definition),
};

local topics(me) = std.mapWithKey(topic(me), lib.getElse(me, 'topics', {}));

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  topics(me)
)
