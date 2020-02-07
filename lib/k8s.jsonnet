{
  helmrelease(name, namespace, version, repo='https://kubernetes-charts.storage.googleapis.com/') {
    apiVersion: 'helm.fluxcd.io/v1',
    kind: 'HelmRelease',
    metadata: {
      annotations: {
        'fluxcd.io/automated': 'false',
      },
      name: name,
      namespace: namespace,
    },
    spec+: {
      chart: {
        name: name,
        repository: repo,
        version: version,
      },
      releaseName: name,
    },
  },

  service(config, pkg):: {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: pkg,
      namespace: $.namespace(config, pkg),
    },
    spec: {
      type: 'ClusterIP',
      ports: [{
        name: 'http',
        protocol: 'TCP',
        port: 8080,
        targetPort: 8080,
      }],
      selector: {
        name: pkg,
      },
    },
  },
}
