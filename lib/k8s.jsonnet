{

  metadata(name, namespace):: {
    metadata: {
      name: name,
      namespace: namespace,
    },
  },

  serviceaccount(name, namespace):: {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: name,
      namespace: namespace,
    },
  },

  clusterrolebinding(name, namespace):: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      labels: {
        app: name,
      },
      name: name,
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: name,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: name,
        namespace: namespace,
      },
    ],
  },

  helmrelease(name, namespace, version, repo='https://kubernetes-charts.storage.googleapis.com'):: $.metadata(name, namespace) {
    apiVersion: 'helm.fluxcd.io/v1',
    kind: 'HelmRelease',
    metadata+: {
      annotations+: {
        'fluxcd.io/automated': 'false',
      },
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

  service(config, name, namespace):: $.metadata(name, namespace) {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: name,
      namespace: namespace,
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
        name: name,
      },
    },
  },
}
