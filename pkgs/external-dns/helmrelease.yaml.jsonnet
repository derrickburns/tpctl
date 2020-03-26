local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('external-dns', me.namespace, '2.20.6', 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master') {
  spec+: {
    values: {
      aws: {
        region: config.cluster.metadata.region,
        zoneType: 'public',
      },
      logLevel: config.general.logLevel,
      metrics: {
        enabled: global.isEnabled(config, 'prometheus'),
        serviceMonitor: {
          enabled: global.isEnabled(config, 'prometheus-operator'),
        },
      },
      provider: 'aws',
      rbac: {
        create: true,
        serviceAccountName: me.pkg,
        serviceAccount: {
          create: false
        },
      },
      txtOwnerId: config.cluster.metadata.name,
      podSecurityContext: {
        fsGroup: 65534,  // For ExternalDNS to be able to read Kubernetes and AWS token files
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
