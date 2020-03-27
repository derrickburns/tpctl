{

  k(apiVersion, kind):: {
    apiVersion: apiVersion,
    kind: kind,
  }, 

  metadata(name, namespace=''):: {
    metadata: {
      name: name,
    } +
    if namespace != '' then { namespace: namespace, } else {},
  },

  serviceaccount(me):: $.k('v1', 'ServiceAccount') + $.metadata(me.pkg, me.namespace),

  configmap(me):: $.k('v1', 'ConfigMap') + $.metadata(me.pkg, me.namespace),

  clusterrolebinding(me):: $.k('rbac.authorization.k8s.io/v1', 'ClusterRoleBinding') + $.metadata(me.pkg) {
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

  basehelmrelease(name, namespace):: $.k('helm.fluxcd.io/v1', 'HelmRelease') + $.metadata(name, namespace) {
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

  service(name, namespace, type='ClusterIP'):: $.k('v1', 'Service') + $.metadata(name, namespace) {
    spec+ {
      type: type,
    },
  },
}
