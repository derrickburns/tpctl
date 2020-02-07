local lib = import '../../lib/lib.jsonnet';
local lib = import '../../lib/k8s.jsonnet';

local helmrelease(config) = k8s.helmrelease('thanos', 'monitoring', '0.3.12', 'https://kubernetes-charts.banzaicloud.com') {
  spec+: {
    values: {
      bucket: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      store: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      query: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      compact: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
    },
  },
};

function(config, prev) helmrelease(config)
