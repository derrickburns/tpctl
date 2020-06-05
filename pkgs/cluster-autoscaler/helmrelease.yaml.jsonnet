local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '7.1.0' }) {
  spec+: {
    values: {
      autoDiscovery: {
        clusterName: me.config.cluster.metadata.name,
      },
      awsRegion: me.config.cluster.metadata.region,
      extraArgs: {
        v: 5,
      },
      image: {
        tag: lib.getElse(me, 'version', 'v1.14.7'),  // XXX
      },
      rbac+: {
        create: true,
        serviceAccount: {
          create: false,
          name: me.pkg,
        },
      },
      fullnameOverride: me.pkg,
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'prometheus-operator'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
