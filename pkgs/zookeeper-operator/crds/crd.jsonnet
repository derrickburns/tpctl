{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    name: 'zookeeperclusters.zookeeper.pravega.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.spec.replicas',
        description: 'The number of ZooKeeper servers in the ensemble',
        name: 'Replicas',
        type: 'integer',
      },
      {
        JSONPath: '.status.readyReplicas',
        description: 'The number of ZooKeeper servers in the ensemble that are in a Ready state',
        name: 'Ready Replicas',
        type: 'integer',
      },
      {
        JSONPath: '.status.currentVersion',
        description: 'The current Zookeeper version',
        name: 'version',
        type: 'string',
      },
      {
        JSONPath: '.spec.image.tag',
        description: 'The desired Zookeeper version',
        name: 'Desired version',
        type: 'string',
      },
      {
        JSONPath: '.status.internalClientEndpoint',
        description: 'Client endpoint internal to cluster network',
        name: 'Internal Endpoint',
        type: 'string',
      },
      {
        JSONPath: '.status.externalClientEndpoint',
        description: 'Client endpoint external to cluster network via LoadBalancer',
        name: 'External Endpoint',
        type: 'string',
      },
      {
        JSONPath: '.metadata.creationTimestamp',
        name: 'Age',
        type: 'date',
      },
    ],
    group: 'zookeeper.pravega.io',
    names: {
      kind: 'ZookeeperCluster',
      listKind: 'ZookeeperClusterList',
      plural: 'zookeeperclusters',
      shortNames: [
        'zk',
      ],
      singular: 'zookeepercluster',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    version: 'v1beta1',
  },
}
