{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'routetables.gateway.solo.io',
  },
  spec: {
    group: 'gateway.solo.io',
    names: {
      kind: 'RouteTable',
      listKind: 'RouteTableList',
      plural: 'routetables',
      shortNames: [
        'rt',
      ],
      singular: 'routetable',
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
