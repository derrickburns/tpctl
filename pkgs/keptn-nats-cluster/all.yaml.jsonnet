local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local natscluster(me) = k8s.k('nats.io/v1alpha2', 'NatsCluster') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    size: 1,
    version: '2.0.0',
  },
};

function(config, prev, namespace, pkg) natscluster(common.package(config, prev, namespace, pkg))
