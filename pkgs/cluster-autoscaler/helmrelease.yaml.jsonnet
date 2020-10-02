local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '1.0.2', repository: 'https://kubernetes.github.io/autoscaler' }) {
  spec+: {
    chart+: {
      name: 'cluster-autoscaler-chart',
    },
    values: {
      autoDiscovery: {
        clusterName: me.config.cluster.metadata.name,
      },
      awsRegion: me.config.cluster.metadata.region,
      extraArgs: {
        v: 5,
      } + lib.getElse(me, 'extraArgs', {}),
      image: {
        tag: lib.getElse(me, 'version', 'v1.14.8'),  // XXX
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
        enabled: global.isEnabled(me.config, 'kube-prometheus-stack'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
