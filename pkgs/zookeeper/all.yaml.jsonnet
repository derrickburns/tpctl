local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local zookeeper(me) = k8s.k('zookeeper.pravega.io/v1beta1', 'ZookeeperCluster') + k8s.metadata(me.pkg, me.namespace) {
  spec+: {
    replicas: 3,
  },
};

function(config, prev, namespace, pkg) zookeeper(common.package(config, prev, namespace, pkg))
