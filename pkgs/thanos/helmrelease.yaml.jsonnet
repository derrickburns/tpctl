local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.3.18', repository: 'https://kubernetes-charts.banzaicloud.com' }) {
  _secretNames:: [ 'thanos' ],

  spec+: {
    values: {
      objstoreSecretOverride: $._secretNames[0],
      image: {
        tag: 'v0.11.0',
      },
      bucket: {
        logLevel: lib.getElse(me.config, 'general.loglevel', 'info'),
        serviceAccount: me.pkg,
      },
      store: {
        logLevel: lib.getElse(me.config, 'general.loglevel', 'info'),
        serviceAccount: me.pkg,
      },
      query: {
        logLevel: lib.getElse(me.config, 'general.loglevel', 'info'),
        serviceAccount: me.pkg,
      },
      compact: {
        logLevel: lib.getElse(me.config, 'general.loglevel', 'info'),
        serviceAccount: me.pkg,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
