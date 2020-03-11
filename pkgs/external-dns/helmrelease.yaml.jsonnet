local lib = import '../../lib/lib.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('external-dns', namespace, '2.20.2') {
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
      },
      txtOwnerId: config.cluster.metadata.name,
      podSecurityContext: {
        fsGroup: 65534,  // For ExternalDNS to be able to read Kubernetes and AWS token files
      },
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
