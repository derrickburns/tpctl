local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '0.3.18', repository: 'https://kubernetes-charts.banzaicloud.com' }) {
  spec+: {
    values: {
      bucket: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
      },
      store: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
      },
      query: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
      },
      compact: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
