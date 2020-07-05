local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.7.1', repository: 'http://storage.googleapis.com/kubernetes-charts-incubator' }) {
  spec+: {
    values: {
      enableWebhook: 'true',
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
