local helmrelease(namespace) = { // XXX use helmrelease lib func
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'reloader',
    namespace: namespace,
  },
  spec: {
    chart: {
      name: 'reloader',
      repository: 'https://stakater.github.io/stakater-charts',
      version: 'v0.0.51',
    },
    releaseName: 'reloader',
    values: {
      reloader: {
        serviceAccount: {
          create: false,
          name: 'reloader',
        },
      },
    },
  },
};

function(config, prev, namespace) helmrelease(namespace)
