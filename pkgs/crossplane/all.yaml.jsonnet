local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '0.12.0', repository: 'https://charts.crossplane.io/alpha' }) {
  spec+: {
    values: {
    },
  },
};

local clusterpackageinstall(me) = {
  apiVersion: 'packages.crossplane.io/v1alpha1',
  kind: 'ClusterPackageInstall',
  metadata: {
    finalizers: [
      'finalizer.packageinstall.crossplane.io',
    ],
    name: 'provider-aws',
    namespace: me.namespace,
  },
  spec: {
    package: 'crossplane/provider-aws:v0.12.0`',
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
     helmrelease(me),
     clusterpackageinstall(me),
  ]
)
