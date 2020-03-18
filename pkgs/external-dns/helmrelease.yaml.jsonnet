local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('external-dns', namespace, '2.20.6', 'https://raw.githubusercontent.com/tidepool-org/tidepool-helm/master') {
  spec+: {
    values: {
      aws: {
        region: config.cluster.metadata.region,
        zoneType: 'public',
      },
      logLevel: config.general.logLevel,
      metrics: {
        enabled: lib.isEnabledAt(config, 'pkgs.prometheus'),
        serviceMonitor: {
          enabled: lib.isEnabledAt(config, 'pkgs.prometheusOperator'),
        },
      },
      provider: 'aws',
      rbac: {
        create: true,
        serviceAccountName: 'external-dns',
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

function(config, prev, namespace, pkg) helmrelease(config, namespace)
