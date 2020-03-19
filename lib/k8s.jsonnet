{

  metadata(name, namespace):: {
    metadata: {
      name: name,
      namespace: namespace,
    },
  },

  serviceaccount(me):: {
    apiVersion: 'v1',
    kind: 'ServiceAccount',
    metadata: {
      name: me.pkg,
      namespace: me.namespace,
    },
  },

  clusterrolebinding(me):: {
    apiVersion: 'rbac.authorization.k8s.io/v1',
    kind: 'ClusterRoleBinding',
    metadata: {
      labels: {
        app: me.pkg,
      },
      name: me.pkg,
    },
    roleRef: {
      apiGroup: 'rbac.authorization.k8s.io',
      kind: 'ClusterRole',
      name: me.pkg,
    },
    subjects: [
      {
        kind: 'ServiceAccount',
        name: me.pkg,
        namespace: me.namespace,
      },
    ],
  },

  basehelmrelease(name, namespace):: $.metadata(name, namespace) {
    apiVersion: 'helm.fluxcd.io/v1',
    kind: 'HelmRelease',
    metadata+: {
      annotations+: {
        'fluxcd.io/automated': 'false',
      },
    },
    spec+: {
      releaseName: name,
    },
  },

  githelmrelease(name, namespace, git, ref='master', path='.'):: $.basehelmrelease(name, namespace) {
    spec+: {
      chart: {
        git: git,
        ref: ref,
        path: path,
      },
    },
  },

  helmrelease(name, namespace, version, repo='https://kubernetes-charts.storage.googleapis.com'):: $.basehelmrelease(name, namespace) {
    spec+: {
      chart: {
        name: name,
        repository: repo,
        version: version,
      },
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
