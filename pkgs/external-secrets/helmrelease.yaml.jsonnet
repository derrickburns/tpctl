local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../linkerd/lib.jsonnet';

local helmrelease(config) = k8s.helmrelease('kubernetes-external-secrets', 'external-secrets', '3.1.0', 'https://godaddy.github.io/kubernetes-external-secrets/') {
  spec+: {
    values: {
      rbac: {
        create: true, 
      },
      podLabels: {
        'sumologic.com/exclude': 'true',
      },
      serviceAccount: {
        create: false,
        name: 'external-secrets',
      },
      securityContext: {
        fsGroup: 65534,
      },
      env: {
        AWS_REGION: config.cluster.metadata.region,
        LOG_LEVEL: config.logLevel,
        POLLER_INTERVAL_MILLISECONDS: lib.getElse(config.pkgs['external-secrets'], 'poller_interval', '120000'),
      },
    },
  },
};

function(config, prev) helmrelease(config)
