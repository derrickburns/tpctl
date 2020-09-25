{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    name: 'natsclusters.nats.io',
  },
  spec: {
    group: 'nats.io',
    names: {
      kind: 'NatsCluster',
      listKind: 'NatsClusterList',
      plural: 'natsclusters',
      shortNames: [
        'nats',
      ],
      singular: 'natscluster',
    },
    scope: 'Namespaced',
    version: 'v1alpha2',
  },
}
