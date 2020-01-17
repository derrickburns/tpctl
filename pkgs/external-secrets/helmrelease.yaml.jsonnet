local lib = import '../../lib/lib.jsonnet';
local linkerd = import '../linkerd/lib.jsonnet';

local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'external-secrets',
    namespace: 'external-secrets',
  },
  spec: {
    chart: {
      git: 'git@github.com:godaddy/kubernetes-external-secrets',
      path: 'charts/kubernetes-external-secrets',
      ref: '3.0.0'
    },
    releaseName: 'external-secrets',
    values: {
      podLabels: {
        'sumologic.com/exclude': 'true',
      },
      podAnnotations: linkerd.annotations(config),
      serviceAccount: {
        create: false,
        name: 'external-secrets',
      },
      securityContext: {
        fsGroup: 1000,
      },
      env: {
        AWS_REGION: config.cluster.metadata.region,
        LOG_LEVEL: config.logLevel,
	POLLER_INTERVAL_MILLISECONDS: lib.getElse(config.pkgs['external-secrets'], 'poller_interval', '120000'),
      }
    },
  },
};

function(config, prev) helmrelease(config)