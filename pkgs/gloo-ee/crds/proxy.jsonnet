{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'proxies.gloo.solo.io',
  },
  spec: {
    group: 'gloo.solo.io',
    names: {
      kind: 'Proxy',
      listKind: 'ProxyList',
      plural: 'proxies',
      shortNames: [
        'px',
      ],
      singular: 'proxy',
    },
    scope: 'Namespaced',
    version: 'v1',
    versions: [
      {
        name: 'v1',
        served: true,
        storage: true,
      },
    ],
  },
}
