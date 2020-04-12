local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease(me, { version: '0.3.18', repository: 'https://kubernetes-charts.banzaicloud.com' }) {
  _secretNames:: [ 'thanos' ],

  spec+: {
    values: {
      objstoreSecretOverride: $.secretNames[0],
      image: {
        tag: 'v0.11.0',
      },
      bucket: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
      },
      store: {
        logLevel: lib.getElse(config, 'general.loglevel', 'info'),
        serviceAccount: me.pkg,
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
