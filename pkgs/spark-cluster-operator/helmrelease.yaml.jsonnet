local global = import '../../global/common.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { path: 'helm/spark-operator', ref: 'master', repository: 'https://github.com/radanalyticsio/spark-operator' }) {
  spec+: {
    values: {
      image: {
        tag: '1.0.8',
      },
      env: {
        watchNamespace: '*',
        installNamespace: me.namespace,
        metrics: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
