{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'virtualservices.gateway.solo.io',
  },
  spec: {
    group: 'gateway.solo.io',
    names: {
      kind: 'VirtualService',
      listKind: 'VirtualServiceList',
      plural: 'virtualservices',
      shortNames: [
        'vs',
      ],
      singular: 'virtualservice',
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
