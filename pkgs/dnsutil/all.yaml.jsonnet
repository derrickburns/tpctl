local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local deployment(me) = k8s.deployment(me) {
  _containers:: {
    command: [
      'sleep',
      '3600',
    ],
    image: 'gcr.io/kubernetes-e2e-test-images/dnsutils:1.3'
  },
};

function(config, prev, namespace, pkg) deployment(common.package(config, prev, namespace, pkg))
