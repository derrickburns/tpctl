{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkatopics.kafka.strimzi.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.spec.partitions',
        description: 'The desired number of partitions in the topic',
        name: 'Partitions',
        type: 'integer',
      },
      {
        JSONPath: '.spec.replicas',
        description: 'The desired number of replicas of each partition',
        name: 'Replication factor',
        type: 'integer',
      },
    ],
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'KafkaTopic',
      listKind: 'KafkaTopicList',
      plural: 'kafkatopics',
      shortNames: [
        'kt',
      ],
      singular: 'kafkatopic',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of the topic.',
            properties: {
              config: {
                description: 'The topic configuration.',
                type: 'object',
              },
              partitions: {
                description: 'The number of partitions the topic should have. This cannot be decreased after topic creation. It can be increased after topic creation, but it is important to understand the consequences that has, especially for topics with semantic partitioning.',
                minimum: 1,
                type: 'integer',
              },
              replicas: {
                description: 'The number of replicas the topic should have.',
                maximum: 32767,
                minimum: 1,
                type: 'integer',
              },
              topicName: {
                description: 'The name of the topic. When absent this will default to the metadata.name of the topic. It is recommended to not set this unless the topic name is not a valid Kubernetes resource name.',
                type: 'string',
              },
            },
            required: [
              'partitions',
              'replicas',
            ],
            type: 'object',
          },
          status: {
            description: 'The status of the topic.',
            properties: {
              conditions: {
                description: 'List of status conditions.',
                items: {
                  properties: {
                    lastTransitionTime: {
                      description: "Last time the condition of a type changed from one status to another. The required format is 'yyyy-MM-ddTHH:mm:ssZ', in the UTC time zone.",
                      type: 'string',
                    },
                    message: {
                      description: "Human-readable message indicating details about the condition's last transition.",
                      type: 'string',
                    },
                    reason: {
                      description: "The reason for the condition's last transition (a single word in CamelCase).",
                      type: 'string',
                    },
                    status: {
                      description: 'The status of the condition, either True, False or Unknown.',
                      type: 'string',
                    },
                    type: {
                      description: 'The unique identifier of a condition, used to distinguish between other conditions in the resource.',
                      type: 'string',
                    },
                  },
                  type: 'object',
                },
                type: 'array',
              },
              observedGeneration: {
                description: 'The generation of the CRD that was last reconciled by the operator.',
                type: 'integer',
              },
            },
            type: 'object',
          },
        },
      },
    },
    version: 'v1beta1',
    versions: [
      {
        name: 'v1beta1',
        served: true,
        storage: true,
      },
      {
        name: 'v1alpha1',
        served: true,
        storage: false,
      },
    ],
  },
}
