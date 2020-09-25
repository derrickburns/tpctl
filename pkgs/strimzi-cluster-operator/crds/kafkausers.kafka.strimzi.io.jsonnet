{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkausers.kafka.strimzi.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.spec.authentication.type',
        description: 'How the user is authenticated',
        name: 'Authentication',
        type: 'string',
      },
      {
        JSONPath: '.spec.authorization.type',
        description: 'How the user is authorised',
        name: 'Authorization',
        type: 'string',
      },
    ],
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'KafkaUser',
      listKind: 'KafkaUserList',
      plural: 'kafkausers',
      shortNames: [
        'ku',
      ],
      singular: 'kafkauser',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of the user.',
            properties: {
              authentication: {
                description: 'Authentication mechanism enabled for this Kafka user.',
                properties: {
                  type: {
                    description: 'Authentication type.',
                    enum: [
                      'tls',
                      'scram-sha-512',
                    ],
                    type: 'string',
                  },
                },
                required: [
                  'type',
                ],
                type: 'object',
              },
              authorization: {
                description: 'Authorization rules for this Kafka user.',
                properties: {
                  acls: {
                    description: 'List of ACL rules which should be applied to this user.',
                    items: {
                      properties: {
                        host: {
                          description: 'The host from which the action described in the ACL rule is allowed or denied.',
                          type: 'string',
                        },
                        operation: {
                          description: 'Operation which will be allowed or denied. Supported operations are: Read, Write, Create, Delete, Alter, Describe, ClusterAction, AlterConfigs, DescribeConfigs, IdempotentWrite and All.',
                          enum: [
                            'Read',
                            'Write',
                            'Create',
                            'Delete',
                            'Alter',
                            'Describe',
                            'ClusterAction',
                            'AlterConfigs',
                            'DescribeConfigs',
                            'IdempotentWrite',
                            'All',
                          ],
                          type: 'string',
                        },
                        resource: {
                          description: 'Indicates the resource for which given ACL rule applies.',
                          properties: {
                            name: {
                              description: 'Name of resource for which given ACL rule applies. Can be combined with `patternType` field to use prefix pattern.',
                              type: 'string',
                            },
                            patternType: {
                              description: 'Describes the pattern used in the resource field. The supported types are `literal` and `prefix`. With `literal` pattern type, the resource field will be used as a definition of a full name. With `prefix` pattern type, the resource name will be used only as a prefix. Default value is `literal`.',
                              enum: [
                                'literal',
                                'prefix',
                              ],
                              type: 'string',
                            },
                            type: {
                              description: 'Resource type. The available resource types are `topic`, `group`, `cluster`, and `transactionalId`.',
                              enum: [
                                'topic',
                                'group',
                                'cluster',
                                'transactionalId',
                              ],
                              type: 'string',
                            },
                          },
                          required: [
                            'type',
                          ],
                          type: 'object',
                        },
                        type: {
                          description: 'The type of the rule. Currently the only supported type is `allow`. ACL rules with type `allow` are used to allow user to execute the specified operations. Default value is `allow`.',
                          enum: [
                            'allow',
                            'deny',
                          ],
                          type: 'string',
                        },
                      },
                      required: [
                        'operation',
                        'resource',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  type: {
                    description: "Authorization type. Currently the only supported type is `simple`. `simple` authorization type uses Kafka's `kafka.security.auth.SimpleAclAuthorizer` class for authorization.",
                    enum: [
                      'simple',
                    ],
                    type: 'string',
                  },
                },
                required: [
                  'acls',
                  'type',
                ],
                type: 'object',
              },
              quotas: {
                description: 'Quotas on requests to control the broker resources used by clients. Network bandwidth and request rate quotas can be enforced.Kafka documentation for Kafka User quotas can be found at http://kafka.apache.org/documentation/#design_quotas.',
                properties: {
                  consumerByteRate: {
                    description: 'A quota on the maximum bytes per-second that each client group can fetch from a broker before the clients in the group are throttled. Defined on a per-broker basis.',
                    minimum: 0,
                    type: 'integer',
                  },
                  producerByteRate: {
                    description: 'A quota on the maximum bytes per-second that each client group can publish to a broker before the clients in the group are throttled. Defined on a per-broker basis.',
                    minimum: 0,
                    type: 'integer',
                  },
                  requestPercentage: {
                    description: 'A quota on the maximum CPU utilization of each client group as a percentage of network and I/O threads.',
                    minimum: 0,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
            },
            type: 'object',
          },
          status: {
            description: 'The status of the Kafka User.',
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
              secret: {
                description: 'The name of `Secret` where the credentials are stored.',
                type: 'string',
              },
              username: {
                description: 'Username.',
                type: 'string',
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
