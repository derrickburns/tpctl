local global = import '../../global/common.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'sparkoperator', version: '0.8.2', repository: 'http://storage.googleapis.com/kubernetes-charts-incubator' }) {
  spec+: {
    values: {
      enableWebhook: true,
      enableMetrics: global.enabled(me.config, 'prometheus-operator'),
      sparkJobNamespace: me.namespace,
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
