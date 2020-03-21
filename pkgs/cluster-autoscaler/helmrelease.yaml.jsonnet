local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('cluster-autoscaler', me.namespace, '7.1.0') {
  spec+: {
    values: {
      autoDiscovery: {
        clusterName: config.cluster.metadata.name,
      },
      awsRegion: config.cluster.metadata.region,
      extraArgs: {
        'scale-down-utilization-threshold': 0.5,
        'skip-nodes-with-local-storage': false,
        'skip-nodes-with-system-pods': false,
        v: 5,
      },
      image: {
        tag: lib.getElse(me, 'version', '1.14.7'), // XXX
      },
      rbac+: {
        create: true,
        name: me.pkg,
        serviceAccount: {
          create: false
        },
      },
      fullnameOverride: me.pkg,
      serviceMonitor: {
        enabled: global.isEnabled(config, 'prometheus-operator'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
