local lib = import '../../lib/lib.jsonnet';

local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'thanos',
    namespace: 'monitoring',
  },
  spec: {
    chart: {
      name: 'thanos',
      repository: 'https://kubernetes-charts.banzaicloud.com',
      version: '0.3.12',
    },
    releaseName: 'thanos',
    values: {
      bucket: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      store: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      query: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
      compact: {
        logLevel: lib.getElse(config, 'loglevel', 'info'),
      },
    },
  },
};

function(config, prev) helmrelease(config)
