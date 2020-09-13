local global = import '../../global/common.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'helm/spark-operator', ref: 'master', repository: 'https://github.com/radanalyticsio/spark-operator'}) {
  spec+: {
    values: {
      env: {
        watchNamespace: "*",
        installNamespace: me.namespace,
        metrics: global.isEnabled(me.config, 'prometheus-operator'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
