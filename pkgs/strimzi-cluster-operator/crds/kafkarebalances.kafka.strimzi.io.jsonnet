{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkarebalances.kafka.strimzi.io',
  },
  spec: {
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'KafkaRebalance',
      listKind: 'KafkaRebalanceList',
      plural: 'kafkarebalances',
      shortNames: [
        'kr',
      ],
      singular: 'kafkarebalance',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of the Kafka rebalance.',
            properties: {
              goals: {
                description: 'A list of goals, ordered by decreasing priority, to use for generating and executing the rebalance proposal. The supported goals are available at https://github.com/linkedin/cruise-control#goals. If an empty goals list is provided, the goals declared in the default.goals Cruise Control configuration parameter are used.',
                items: {
                  type: 'string',
                },
                type: 'array',
              },
              skipHardGoalCheck: {
                description: 'Whether to allow the hard goals specified in the Kafka CR to be skipped in rebalance proposal generation. This can be useful when some of those hard goals are preventing a balance solution being found. Default is false.',
                type: 'boolean',
              },
            },
            type: 'object',
          },
          status: {
            description: 'The status of the Kafka rebalance.',
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
              optimizationResult: {
                description: 'A JSON object describing the optimization result.',
                type: 'object',
              },
              sessionId: {
                description: 'The session identifier for requests to Cruise Control pertaining to this KafkaRebalance resource. This is used by the Kafka Rebalance operator to track the status of ongoing rebalancing operations.',
                type: 'string',
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
