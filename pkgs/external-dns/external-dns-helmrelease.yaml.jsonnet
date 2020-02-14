local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config) = k8s.helmrelease('external-dns', 'external-dns', '2.6.1') {
  spec+: {
    values: {
      aws: {
        region: config.cluster.metadata.region,
        zoneType: 'public',
      },
      logLevel: config.general.logLevel,
      metrics: {
        enabled: true,
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

function(config, prev) helmrelease(config)
