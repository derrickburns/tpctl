local helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'kuberetes-dashboard',
    namespace: 'kube-system',
  },
  spec: {
    chart: {
      name: 'kubernetes-dashboard'
      repository: 'https://kubernetes-charts.storage.googleapis.com/',
      version: '1.10.1',
    },
    releaseName: 'kubernetes-dashboard',
    values: {
      ingress {
        enabled: false
      },
      enableSkipLogin: "true",
    },
  },
};

function(config, prev) helmrelease(config)
