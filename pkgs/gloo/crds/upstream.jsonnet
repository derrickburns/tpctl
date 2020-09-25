{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'upstreams.gloo.solo.io',
  },
  spec: {
    group: 'gloo.solo.io',
    names: {
      kind: 'Upstream',
      listKind: 'UpstreamList',
      plural: 'upstreams',
      shortNames: [
        'us',
      ],
      singular: 'upstream',
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
