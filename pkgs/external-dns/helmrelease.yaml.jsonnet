local global = import '../../lib/global.jsonnet';
local common = import '../../lib/common.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { version: '2.20.8', repository: 'https://charts.bitnami.com/bitnami' }) {
  spec+: {
    values: {
      aws: {
        region: me.config.cluster.metadata.region,
        zoneType: 'public',
      },
      logLevel: me.config.general.logLevel,
      metrics: {
        enabled: global.isEnabled(me.config, 'prometheus'),
        serviceMonitor: {
          enabled: global.isEnabled(me.config, 'prometheus-operator'),
        },
      },
      provider: 'aws',
      rbac: {
        create: true,
        serviceAccountName: me.pkg,
      },
      txtOwnerId: me.config.cluster.metadata.name,
      podSecurityContext: {
        fsGroup: 65534,  // For ExternalDNS to be able to read Kubernetes and AWS token files
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
