local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local kafkatopic(me) = k8s.k('kafka.strimzi.io/v1beta1', 'KafkaTopic') + k8s.metadata(me.pkg, me.namespace) {
  metadata+: {
    labels: {
      'strimzi.io/cluster': lib.getElse(me, 'cluster', me.pkg),
    },
  },
  spec: lib.merge({
    partitions: 1,
    replicas: 1,
  }, lib.getElse(me, 'spec', {})),
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  kafkatopic(me)
)
