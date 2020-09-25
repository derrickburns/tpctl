{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkaconnectors.kafka.strimzi.io',
  },
  spec: {
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'KafkaConnector',
      listKind: 'KafkaConnectorList',
      plural: 'kafkaconnectors',
      shortNames: [
        'kctr',
      ],
      singular: 'kafkaconnector',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of the Kafka Connector.',
            properties: {
              class: {
                description: 'The Class for the Kafka Connector.',
                type: 'string',
              },
              config: {
                description: 'The Kafka Connector configuration. The following properties cannot be set: connector.class, tasks.max.',
                type: 'object',
              },
              pause: {
                description: 'Whether the connector should be paused. Defaults to false.',
                type: 'boolean',
              },
              tasksMax: {
                description: 'The maximum number of tasks for the Kafka Connector.',
                minimum: 1,
                type: 'integer',
              },
            },
            type: 'object',
          },
          status: {
            description: 'The status of the Kafka Connector.',
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
              connectorStatus: {
                description: 'The connector status, as reported by the Kafka Connect REST API.',
                type: 'object',
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
    version: 'v1alpha1',
    versions: [
      {
        name: 'v1alpha1',
        served: true,
        storage: true,
      },
    ],
  },
}
