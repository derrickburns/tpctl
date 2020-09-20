local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../k8s/lib.jsonnet';

{
  kafkatopic(me):: k8s.k('kafka.strimzi.io/v1beta1', 'KafkaTopic') + k8s.metadata( me.pkg, me.namespace) {
  metadata+: {
    labels: {
      'strimzi.io/cluster': lib.getElse(me, 'cluster', me.pkg),
    },
  },
  spec: lib.merge({
    partitions: 1,
    replicas: 1,
  }, lib.getElse(me, 'spec', {}))
}
}