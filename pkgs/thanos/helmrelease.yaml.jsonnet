local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local secretName = 'thanos';

local helmrelease(me) = k8s.helmrelease(
  me,
  { version: '0.3.21', repository: 'https://kubernetes-charts.banzaicloud.com' },
  secretNames=[secretName]
)
                        {
  spec+: {
    values: {
      objstoreSecretOverride: secretName,
      image: {
        tag: 'v0.12.2',
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
