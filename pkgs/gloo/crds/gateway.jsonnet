{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'helm.sh/hook': 'crd-install',
    },
    name: 'gateways.gateway.solo.io',
  },
  spec: {
    group: 'gateway.solo.io',
    names: {
      kind: 'Gateway',
      listKind: 'GatewayList',
      plural: 'gateways',
      shortNames: [
        'gw',
      ],
      singular: 'gateway',
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
