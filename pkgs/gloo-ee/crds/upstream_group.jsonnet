{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'upstreamgroups.gloo.solo.io',
  },
  spec: {
    group: 'gloo.solo.io',
    names: {
      kind: 'UpstreamGroup',
      listKind: 'UpstreamGroupList',
      plural: 'upstreamgroups',
      shortNames: [
        'ug',
      ],
      singular: 'upstreamgroup',
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
