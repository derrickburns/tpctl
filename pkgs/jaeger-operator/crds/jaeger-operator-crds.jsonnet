{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    annotations: {
      'controller-gen.kubebuilder.io/version': 'v0.2.4',
    },
    creationTimestamp: null,
    name: 'jaegers.jaegertracing.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.status.phase',
        description: "Jaeger instance's status",
        name: 'Status',
        type: 'string',
      },
      {
        JSONPath: '.status.version',
        description: 'Jaeger Version',
        name: 'Version',
        type: 'string',
      },
      {
        JSONPath: '.spec.strategy',
        description: 'Jaeger deployment strategy',
        name: 'Strategy',
        type: 'string',
      },
      {
        JSONPath: '.spec.storage.type',
        description: 'Jaeger storage type',
        name: 'Storage',
        type: 'string',
      },
      {
        JSONPath: '.metadata.creationTimestamp',
        name: 'Age',
        type: 'date',
      },
    ],
    group: 'jaegertracing.io',
    names: {
      kind: 'Jaeger',
      listKind: 'JaegerList',
      plural: 'jaegers',
      singular: 'jaeger',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          apiVersion: {
            type: 'string',
          },
          kind: {
            type: 'string',
          },
          metadata: {
            type: 'object',
          },
          spec: {
            properties: {
              affinity: {
                properties: {
                  nodeAffinity: {
                    properties: {
                      preferredDuringSchedulingIgnoredDuringExecution: {
                        items: {
                          properties: {
                            preference: {
                              properties: {
                                matchExpressions: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchFields: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            weight: {
                              format: 'int32',
                              type: 'integer',
                            },
                          },
                          required: [
                            'preference',
                            'weight',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      requiredDuringSchedulingIgnoredDuringExecution: {
                        properties: {
                          nodeSelectorTerms: {
                            items: {
                              properties: {
                                matchExpressions: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchFields: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        required: [
                          'nodeSelectorTerms',
                        ],
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  podAffinity: {
                    properties: {
                      preferredDuringSchedulingIgnoredDuringExecution: {
                        items: {
                          properties: {
                            podAffinityTerm: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            weight: {
                              format: 'int32',
                              type: 'integer',
                            },
                          },
                          required: [
                            'podAffinityTerm',
                            'weight',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      requiredDuringSchedulingIgnoredDuringExecution: {
                        items: {
                          properties: {
                            labelSelector: {
                              properties: {
                                matchExpressions: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchLabels: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                              },
                              type: 'object',
                            },
                            namespaces: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            topologyKey: {
                              type: 'string',
                            },
                          },
                          required: [
                            'topologyKey',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                  podAntiAffinity: {
                    properties: {
                      preferredDuringSchedulingIgnoredDuringExecution: {
                        items: {
                          properties: {
                            podAffinityTerm: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            weight: {
                              format: 'int32',
                              type: 'integer',
                            },
                          },
                          required: [
                            'podAffinityTerm',
                            'weight',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      requiredDuringSchedulingIgnoredDuringExecution: {
                        items: {
                          properties: {
                            labelSelector: {
                              properties: {
                                matchExpressions: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      operator: {
                                        type: 'string',
                                      },
                                      values: {
                                        items: {
                                          type: 'string',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'operator',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchLabels: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                              },
                              type: 'object',
                            },
                            namespaces: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            topologyKey: {
                              type: 'string',
                            },
                          },
                          required: [
                            'topologyKey',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              agent: {
                nullable: true,
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  config: {
                    type: 'object',
                  },
                  image: {
                    type: 'string',
                  },
                  imagePullSecrets: {
                    items: {
                      properties: {
                        name: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  options: {
                    type: 'object',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  strategy: {
                    type: 'string',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              allInOne: {
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  config: {
                    type: 'object',
                  },
                  image: {
                    type: 'string',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  options: {
                    type: 'object',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              annotations: {
                additionalProperties: {
                  type: 'string',
                },
                nullable: true,
                type: 'object',
              },
              collector: {
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  autoscale: {
                    type: 'boolean',
                  },
                  config: {
                    type: 'object',
                  },
                  image: {
                    type: 'string',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  maxReplicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  minReplicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  options: {
                    type: 'object',
                  },
                  replicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              ingester: {
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  autoscale: {
                    type: 'boolean',
                  },
                  config: {
                    type: 'object',
                  },
                  image: {
                    type: 'string',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  maxReplicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  minReplicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  options: {
                    type: 'object',
                  },
                  replicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              ingress: {
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  enabled: {
                    type: 'boolean',
                  },
                  hosts: {
                    items: {
                      type: 'string',
                    },
                    type: 'array',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  openshift: {
                    properties: {
                      delegateUrls: {
                        type: 'string',
                      },
                      htpasswdFile: {
                        type: 'string',
                      },
                      sar: {
                        type: 'string',
                      },
                      skipLogout: {
                        type: 'boolean',
                      },
                    },
                    type: 'object',
                  },
                  options: {
                    type: 'object',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  secretName: {
                    type: 'string',
                  },
                  security: {
                    type: 'string',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  tls: {
                    items: {
                      properties: {
                        hosts: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        secretName: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              labels: {
                additionalProperties: {
                  type: 'string',
                },
                type: 'object',
              },
              query: {
                properties: {
                  affinity: {
                    properties: {
                      nodeAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                preference: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'preference',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            properties: {
                              nodeSelectorTerms: {
                                items: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchFields: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            required: [
                              'nodeSelectorTerms',
                            ],
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      podAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      podAntiAffinity: {
                        properties: {
                          preferredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                podAffinityTerm: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                weight: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                              },
                              required: [
                                'podAffinityTerm',
                                'weight',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          requiredDuringSchedulingIgnoredDuringExecution: {
                            items: {
                              properties: {
                                labelSelector: {
                                  properties: {
                                    matchExpressions: {
                                      items: {
                                        properties: {
                                          key: {
                                            type: 'string',
                                          },
                                          operator: {
                                            type: 'string',
                                          },
                                          values: {
                                            items: {
                                              type: 'string',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        required: [
                                          'key',
                                          'operator',
                                        ],
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
                                      additionalProperties: {
                                        type: 'string',
                                      },
                                      type: 'object',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaces: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                topologyKey: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'topologyKey',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  annotations: {
                    additionalProperties: {
                      type: 'string',
                    },
                    nullable: true,
                    type: 'object',
                  },
                  image: {
                    type: 'string',
                  },
                  labels: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  options: {
                    type: 'object',
                  },
                  replicas: {
                    format: 'int32',
                    type: 'integer',
                  },
                  resources: {
                    nullable: true,
                    properties: {
                      limits: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      requests: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  securityContext: {
                    properties: {
                      fsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      fsGroupChangePolicy: {
                        type: 'string',
                      },
                      runAsGroup: {
                        format: 'int64',
                        type: 'integer',
                      },
                      runAsNonRoot: {
                        type: 'boolean',
                      },
                      runAsUser: {
                        format: 'int64',
                        type: 'integer',
                      },
                      seLinuxOptions: {
                        properties: {
                          level: {
                            type: 'string',
                          },
                          role: {
                            type: 'string',
                          },
                          type: {
                            type: 'string',
                          },
                          user: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      supplementalGroups: {
                        items: {
                          format: 'int64',
                          type: 'integer',
                        },
                        type: 'array',
                      },
                      sysctls: {
                        items: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          required: [
                            'name',
                            'value',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      windowsOptions: {
                        properties: {
                          gmsaCredentialSpec: {
                            type: 'string',
                          },
                          gmsaCredentialSpecName: {
                            type: 'string',
                          },
                          runAsUserName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  serviceAccount: {
                    type: 'string',
                  },
                  serviceType: {
                    type: 'string',
                  },
                  tolerations: {
                    items: {
                      properties: {
                        effect: {
                          type: 'string',
                        },
                        key: {
                          type: 'string',
                        },
                        operator: {
                          type: 'string',
                        },
                        tolerationSeconds: {
                          format: 'int64',
                          type: 'integer',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumeMounts: {
                    items: {
                      properties: {
                        mountPath: {
                          type: 'string',
                        },
                        mountPropagation: {
                          type: 'string',
                        },
                        name: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        subPath: {
                          type: 'string',
                        },
                        subPathExpr: {
                          type: 'string',
                        },
                      },
                      required: [
                        'mountPath',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  volumes: {
                    items: {
                      properties: {
                        awsElasticBlockStore: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        azureDisk: {
                          properties: {
                            cachingMode: {
                              type: 'string',
                            },
                            diskName: {
                              type: 'string',
                            },
                            diskURI: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            kind: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'diskName',
                            'diskURI',
                          ],
                          type: 'object',
                        },
                        azureFile: {
                          properties: {
                            readOnly: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                            shareName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'secretName',
                            'shareName',
                          ],
                          type: 'object',
                        },
                        cephfs: {
                          properties: {
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretFile: {
                              type: 'string',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'monitors',
                          ],
                          type: 'object',
                        },
                        cinder: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        configMap: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            name: {
                              type: 'string',
                            },
                            optional: {
                              type: 'boolean',
                            },
                          },
                          type: 'object',
                        },
                        csi: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            nodePublishSecretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeAttributes: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        downwardAPI: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  fieldRef: {
                                    properties: {
                                      apiVersion: {
                                        type: 'string',
                                      },
                                      fieldPath: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'fieldPath',
                                    ],
                                    type: 'object',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                  resourceFieldRef: {
                                    properties: {
                                      containerName: {
                                        type: 'string',
                                      },
                                      divisor: {
                                        type: 'string',
                                      },
                                      resource: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'resource',
                                    ],
                                    type: 'object',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        emptyDir: {
                          properties: {
                            medium: {
                              type: 'string',
                            },
                            sizeLimit: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        fc: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            targetWWNs: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            wwids: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                          },
                          type: 'object',
                        },
                        flexVolume: {
                          properties: {
                            driver: {
                              type: 'string',
                            },
                            fsType: {
                              type: 'string',
                            },
                            options: {
                              additionalProperties: {
                                type: 'string',
                              },
                              type: 'object',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                          },
                          required: [
                            'driver',
                          ],
                          type: 'object',
                        },
                        flocker: {
                          properties: {
                            datasetName: {
                              type: 'string',
                            },
                            datasetUUID: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        gcePersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            partition: {
                              format: 'int32',
                              type: 'integer',
                            },
                            pdName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'pdName',
                          ],
                          type: 'object',
                        },
                        gitRepo: {
                          properties: {
                            directory: {
                              type: 'string',
                            },
                            repository: {
                              type: 'string',
                            },
                            revision: {
                              type: 'string',
                            },
                          },
                          required: [
                            'repository',
                          ],
                          type: 'object',
                        },
                        glusterfs: {
                          properties: {
                            endpoints: {
                              type: 'string',
                            },
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'endpoints',
                            'path',
                          ],
                          type: 'object',
                        },
                        hostPath: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            type: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                          ],
                          type: 'object',
                        },
                        iscsi: {
                          properties: {
                            chapAuthDiscovery: {
                              type: 'boolean',
                            },
                            chapAuthSession: {
                              type: 'boolean',
                            },
                            fsType: {
                              type: 'string',
                            },
                            initiatorName: {
                              type: 'string',
                            },
                            iqn: {
                              type: 'string',
                            },
                            iscsiInterface: {
                              type: 'string',
                            },
                            lun: {
                              format: 'int32',
                              type: 'integer',
                            },
                            portals: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            targetPortal: {
                              type: 'string',
                            },
                          },
                          required: [
                            'iqn',
                            'lun',
                            'targetPortal',
                          ],
                          type: 'object',
                        },
                        name: {
                          type: 'string',
                        },
                        nfs: {
                          properties: {
                            path: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            server: {
                              type: 'string',
                            },
                          },
                          required: [
                            'path',
                            'server',
                          ],
                          type: 'object',
                        },
                        persistentVolumeClaim: {
                          properties: {
                            claimName: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                          },
                          required: [
                            'claimName',
                          ],
                          type: 'object',
                        },
                        photonPersistentDisk: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            pdID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'pdID',
                          ],
                          type: 'object',
                        },
                        portworxVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            volumeID: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumeID',
                          ],
                          type: 'object',
                        },
                        projected: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            sources: {
                              items: {
                                properties: {
                                  configMap: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  downwardAPI: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            fieldRef: {
                                              properties: {
                                                apiVersion: {
                                                  type: 'string',
                                                },
                                                fieldPath: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'fieldPath',
                                              ],
                                              type: 'object',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                            resourceFieldRef: {
                                              properties: {
                                                containerName: {
                                                  type: 'string',
                                                },
                                                divisor: {
                                                  type: 'string',
                                                },
                                                resource: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'resource',
                                              ],
                                              type: 'object',
                                            },
                                          },
                                          required: [
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  secret: {
                                    properties: {
                                      items: {
                                        items: {
                                          properties: {
                                            key: {
                                              type: 'string',
                                            },
                                            mode: {
                                              format: 'int32',
                                              type: 'integer',
                                            },
                                            path: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'key',
                                            'path',
                                          ],
                                          type: 'object',
                                        },
                                        type: 'array',
                                      },
                                      name: {
                                        type: 'string',
                                      },
                                      optional: {
                                        type: 'boolean',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  serviceAccountToken: {
                                    properties: {
                                      audience: {
                                        type: 'string',
                                      },
                                      expirationSeconds: {
                                        format: 'int64',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                          },
                          required: [
                            'sources',
                          ],
                          type: 'object',
                        },
                        quobyte: {
                          properties: {
                            group: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            registry: {
                              type: 'string',
                            },
                            tenant: {
                              type: 'string',
                            },
                            user: {
                              type: 'string',
                            },
                            volume: {
                              type: 'string',
                            },
                          },
                          required: [
                            'registry',
                            'volume',
                          ],
                          type: 'object',
                        },
                        rbd: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            image: {
                              type: 'string',
                            },
                            keyring: {
                              type: 'string',
                            },
                            monitors: {
                              items: {
                                type: 'string',
                              },
                              type: 'array',
                            },
                            pool: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            user: {
                              type: 'string',
                            },
                          },
                          required: [
                            'image',
                            'monitors',
                          ],
                          type: 'object',
                        },
                        scaleIO: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            gateway: {
                              type: 'string',
                            },
                            protectionDomain: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            sslEnabled: {
                              type: 'boolean',
                            },
                            storageMode: {
                              type: 'string',
                            },
                            storagePool: {
                              type: 'string',
                            },
                            system: {
                              type: 'string',
                            },
                            volumeName: {
                              type: 'string',
                            },
                          },
                          required: [
                            'gateway',
                            'secretRef',
                            'system',
                          ],
                          type: 'object',
                        },
                        secret: {
                          properties: {
                            defaultMode: {
                              format: 'int32',
                              type: 'integer',
                            },
                            items: {
                              items: {
                                properties: {
                                  key: {
                                    type: 'string',
                                  },
                                  mode: {
                                    format: 'int32',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'key',
                                  'path',
                                ],
                                type: 'object',
                              },
                              type: 'array',
                            },
                            optional: {
                              type: 'boolean',
                            },
                            secretName: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        storageos: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            secretRef: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            volumeName: {
                              type: 'string',
                            },
                            volumeNamespace: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        vsphereVolume: {
                          properties: {
                            fsType: {
                              type: 'string',
                            },
                            storagePolicyID: {
                              type: 'string',
                            },
                            storagePolicyName: {
                              type: 'string',
                            },
                            volumePath: {
                              type: 'string',
                            },
                          },
                          required: [
                            'volumePath',
                          ],
                          type: 'object',
                        },
                      },
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              resources: {
                nullable: true,
                properties: {
                  limits: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                  requests: {
                    additionalProperties: {
                      type: 'string',
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              sampling: {
                properties: {
                  options: {
                    type: 'object',
                  },
                },
                type: 'object',
              },
              securityContext: {
                properties: {
                  fsGroup: {
                    format: 'int64',
                    type: 'integer',
                  },
                  fsGroupChangePolicy: {
                    type: 'string',
                  },
                  runAsGroup: {
                    format: 'int64',
                    type: 'integer',
                  },
                  runAsNonRoot: {
                    type: 'boolean',
                  },
                  runAsUser: {
                    format: 'int64',
                    type: 'integer',
                  },
                  seLinuxOptions: {
                    properties: {
                      level: {
                        type: 'string',
                      },
                      role: {
                        type: 'string',
                      },
                      type: {
                        type: 'string',
                      },
                      user: {
                        type: 'string',
                      },
                    },
                    type: 'object',
                  },
                  supplementalGroups: {
                    items: {
                      format: 'int64',
                      type: 'integer',
                    },
                    type: 'array',
                  },
                  sysctls: {
                    items: {
                      properties: {
                        name: {
                          type: 'string',
                        },
                        value: {
                          type: 'string',
                        },
                      },
                      required: [
                        'name',
                        'value',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  windowsOptions: {
                    properties: {
                      gmsaCredentialSpec: {
                        type: 'string',
                      },
                      gmsaCredentialSpecName: {
                        type: 'string',
                      },
                      runAsUserName: {
                        type: 'string',
                      },
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              serviceAccount: {
                type: 'string',
              },
              storage: {
                properties: {
                  cassandraCreateSchema: {
                    properties: {
                      datacenter: {
                        type: 'string',
                      },
                      enabled: {
                        type: 'boolean',
                      },
                      image: {
                        type: 'string',
                      },
                      mode: {
                        type: 'string',
                      },
                      timeout: {
                        type: 'string',
                      },
                      traceTTL: {
                        type: 'string',
                      },
                      ttlSecondsAfterFinished: {
                        format: 'int32',
                        type: 'integer',
                      },
                    },
                    type: 'object',
                  },
                  dependencies: {
                    properties: {
                      affinity: {
                        properties: {
                          nodeAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    preference: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'preference',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                properties: {
                                  nodeSelectorTerms: {
                                    items: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'nodeSelectorTerms',
                                ],
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          podAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          podAntiAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      annotations: {
                        additionalProperties: {
                          type: 'string',
                        },
                        nullable: true,
                        type: 'object',
                      },
                      cassandraClientAuthEnabled: {
                        type: 'boolean',
                      },
                      elasticsearchClientNodeOnly: {
                        type: 'boolean',
                      },
                      elasticsearchNodesWanOnly: {
                        type: 'boolean',
                      },
                      enabled: {
                        type: 'boolean',
                      },
                      image: {
                        type: 'string',
                      },
                      javaOpts: {
                        type: 'string',
                      },
                      labels: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      resources: {
                        nullable: true,
                        properties: {
                          limits: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                          requests: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      schedule: {
                        type: 'string',
                      },
                      securityContext: {
                        properties: {
                          fsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          fsGroupChangePolicy: {
                            type: 'string',
                          },
                          runAsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          runAsNonRoot: {
                            type: 'boolean',
                          },
                          runAsUser: {
                            format: 'int64',
                            type: 'integer',
                          },
                          seLinuxOptions: {
                            properties: {
                              level: {
                                type: 'string',
                              },
                              role: {
                                type: 'string',
                              },
                              type: {
                                type: 'string',
                              },
                              user: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          supplementalGroups: {
                            items: {
                              format: 'int64',
                              type: 'integer',
                            },
                            type: 'array',
                          },
                          sysctls: {
                            items: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                                value: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'name',
                                'value',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          windowsOptions: {
                            properties: {
                              gmsaCredentialSpec: {
                                type: 'string',
                              },
                              gmsaCredentialSpecName: {
                                type: 'string',
                              },
                              runAsUserName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      serviceAccount: {
                        type: 'string',
                      },
                      sparkMaster: {
                        type: 'string',
                      },
                      successfulJobsHistoryLimit: {
                        format: 'int32',
                        type: 'integer',
                      },
                      tolerations: {
                        items: {
                          properties: {
                            effect: {
                              type: 'string',
                            },
                            key: {
                              type: 'string',
                            },
                            operator: {
                              type: 'string',
                            },
                            tolerationSeconds: {
                              format: 'int64',
                              type: 'integer',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      ttlSecondsAfterFinished: {
                        format: 'int32',
                        type: 'integer',
                      },
                      volumeMounts: {
                        items: {
                          properties: {
                            mountPath: {
                              type: 'string',
                            },
                            mountPropagation: {
                              type: 'string',
                            },
                            name: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            subPath: {
                              type: 'string',
                            },
                            subPathExpr: {
                              type: 'string',
                            },
                          },
                          required: [
                            'mountPath',
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      volumes: {
                        items: {
                          properties: {
                            awsElasticBlockStore: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            azureDisk: {
                              properties: {
                                cachingMode: {
                                  type: 'string',
                                },
                                diskName: {
                                  type: 'string',
                                },
                                diskURI: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                kind: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'diskName',
                                'diskURI',
                              ],
                              type: 'object',
                            },
                            azureFile: {
                              properties: {
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                                shareName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'secretName',
                                'shareName',
                              ],
                              type: 'object',
                            },
                            cephfs: {
                              properties: {
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretFile: {
                                  type: 'string',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'monitors',
                              ],
                              type: 'object',
                            },
                            cinder: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            configMap: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                name: {
                                  type: 'string',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                              },
                              type: 'object',
                            },
                            csi: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                nodePublishSecretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeAttributes: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            downwardAPI: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      fieldRef: {
                                        properties: {
                                          apiVersion: {
                                            type: 'string',
                                          },
                                          fieldPath: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'fieldPath',
                                        ],
                                        type: 'object',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                      resourceFieldRef: {
                                        properties: {
                                          containerName: {
                                            type: 'string',
                                          },
                                          divisor: {
                                            type: 'string',
                                          },
                                          resource: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'resource',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            emptyDir: {
                              properties: {
                                medium: {
                                  type: 'string',
                                },
                                sizeLimit: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            fc: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                targetWWNs: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                wwids: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            flexVolume: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                options: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            flocker: {
                              properties: {
                                datasetName: {
                                  type: 'string',
                                },
                                datasetUUID: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            gcePersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                pdName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'pdName',
                              ],
                              type: 'object',
                            },
                            gitRepo: {
                              properties: {
                                directory: {
                                  type: 'string',
                                },
                                repository: {
                                  type: 'string',
                                },
                                revision: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'repository',
                              ],
                              type: 'object',
                            },
                            glusterfs: {
                              properties: {
                                endpoints: {
                                  type: 'string',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'endpoints',
                                'path',
                              ],
                              type: 'object',
                            },
                            hostPath: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                type: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                              ],
                              type: 'object',
                            },
                            iscsi: {
                              properties: {
                                chapAuthDiscovery: {
                                  type: 'boolean',
                                },
                                chapAuthSession: {
                                  type: 'boolean',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                initiatorName: {
                                  type: 'string',
                                },
                                iqn: {
                                  type: 'string',
                                },
                                iscsiInterface: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                portals: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                targetPortal: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'iqn',
                                'lun',
                                'targetPortal',
                              ],
                              type: 'object',
                            },
                            name: {
                              type: 'string',
                            },
                            nfs: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                server: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                                'server',
                              ],
                              type: 'object',
                            },
                            persistentVolumeClaim: {
                              properties: {
                                claimName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'claimName',
                              ],
                              type: 'object',
                            },
                            photonPersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                pdID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'pdID',
                              ],
                              type: 'object',
                            },
                            portworxVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            projected: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                sources: {
                                  items: {
                                    properties: {
                                      configMap: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      downwardAPI: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                fieldRef: {
                                                  properties: {
                                                    apiVersion: {
                                                      type: 'string',
                                                    },
                                                    fieldPath: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'fieldPath',
                                                  ],
                                                  type: 'object',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                                resourceFieldRef: {
                                                  properties: {
                                                    containerName: {
                                                      type: 'string',
                                                    },
                                                    divisor: {
                                                      type: 'string',
                                                    },
                                                    resource: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'resource',
                                                  ],
                                                  type: 'object',
                                                },
                                              },
                                              required: [
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      secret: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      serviceAccountToken: {
                                        properties: {
                                          audience: {
                                            type: 'string',
                                          },
                                          expirationSeconds: {
                                            format: 'int64',
                                            type: 'integer',
                                          },
                                          path: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'path',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              required: [
                                'sources',
                              ],
                              type: 'object',
                            },
                            quobyte: {
                              properties: {
                                group: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                registry: {
                                  type: 'string',
                                },
                                tenant: {
                                  type: 'string',
                                },
                                user: {
                                  type: 'string',
                                },
                                volume: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'registry',
                                'volume',
                              ],
                              type: 'object',
                            },
                            rbd: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                image: {
                                  type: 'string',
                                },
                                keyring: {
                                  type: 'string',
                                },
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                pool: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'image',
                                'monitors',
                              ],
                              type: 'object',
                            },
                            scaleIO: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                gateway: {
                                  type: 'string',
                                },
                                protectionDomain: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                sslEnabled: {
                                  type: 'boolean',
                                },
                                storageMode: {
                                  type: 'string',
                                },
                                storagePool: {
                                  type: 'string',
                                },
                                system: {
                                  type: 'string',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'gateway',
                                'secretRef',
                                'system',
                              ],
                              type: 'object',
                            },
                            secret: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            storageos: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                                volumeNamespace: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            vsphereVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                storagePolicyID: {
                                  type: 'string',
                                },
                                storagePolicyName: {
                                  type: 'string',
                                },
                                volumePath: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumePath',
                              ],
                              type: 'object',
                            },
                          },
                          required: [
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                  elasticsearch: {
                    properties: {
                      image: {
                        type: 'string',
                      },
                      nodeCount: {
                        format: 'int32',
                        type: 'integer',
                      },
                      nodeSelector: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      redundancyPolicy: {
                        type: 'string',
                      },
                      resources: {
                        properties: {
                          limits: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                          requests: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      storage: {
                        properties: {
                          size: {
                            type: 'string',
                          },
                          storageClassName: {
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  esIndexCleaner: {
                    properties: {
                      affinity: {
                        properties: {
                          nodeAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    preference: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'preference',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                properties: {
                                  nodeSelectorTerms: {
                                    items: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'nodeSelectorTerms',
                                ],
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          podAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          podAntiAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      annotations: {
                        additionalProperties: {
                          type: 'string',
                        },
                        nullable: true,
                        type: 'object',
                      },
                      enabled: {
                        type: 'boolean',
                      },
                      image: {
                        type: 'string',
                      },
                      labels: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      numberOfDays: {
                        type: 'integer',
                      },
                      resources: {
                        nullable: true,
                        properties: {
                          limits: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                          requests: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      schedule: {
                        type: 'string',
                      },
                      securityContext: {
                        properties: {
                          fsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          fsGroupChangePolicy: {
                            type: 'string',
                          },
                          runAsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          runAsNonRoot: {
                            type: 'boolean',
                          },
                          runAsUser: {
                            format: 'int64',
                            type: 'integer',
                          },
                          seLinuxOptions: {
                            properties: {
                              level: {
                                type: 'string',
                              },
                              role: {
                                type: 'string',
                              },
                              type: {
                                type: 'string',
                              },
                              user: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          supplementalGroups: {
                            items: {
                              format: 'int64',
                              type: 'integer',
                            },
                            type: 'array',
                          },
                          sysctls: {
                            items: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                                value: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'name',
                                'value',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          windowsOptions: {
                            properties: {
                              gmsaCredentialSpec: {
                                type: 'string',
                              },
                              gmsaCredentialSpecName: {
                                type: 'string',
                              },
                              runAsUserName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      serviceAccount: {
                        type: 'string',
                      },
                      successfulJobsHistoryLimit: {
                        format: 'int32',
                        type: 'integer',
                      },
                      tolerations: {
                        items: {
                          properties: {
                            effect: {
                              type: 'string',
                            },
                            key: {
                              type: 'string',
                            },
                            operator: {
                              type: 'string',
                            },
                            tolerationSeconds: {
                              format: 'int64',
                              type: 'integer',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      ttlSecondsAfterFinished: {
                        format: 'int32',
                        type: 'integer',
                      },
                      volumeMounts: {
                        items: {
                          properties: {
                            mountPath: {
                              type: 'string',
                            },
                            mountPropagation: {
                              type: 'string',
                            },
                            name: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            subPath: {
                              type: 'string',
                            },
                            subPathExpr: {
                              type: 'string',
                            },
                          },
                          required: [
                            'mountPath',
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      volumes: {
                        items: {
                          properties: {
                            awsElasticBlockStore: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            azureDisk: {
                              properties: {
                                cachingMode: {
                                  type: 'string',
                                },
                                diskName: {
                                  type: 'string',
                                },
                                diskURI: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                kind: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'diskName',
                                'diskURI',
                              ],
                              type: 'object',
                            },
                            azureFile: {
                              properties: {
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                                shareName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'secretName',
                                'shareName',
                              ],
                              type: 'object',
                            },
                            cephfs: {
                              properties: {
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretFile: {
                                  type: 'string',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'monitors',
                              ],
                              type: 'object',
                            },
                            cinder: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            configMap: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                name: {
                                  type: 'string',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                              },
                              type: 'object',
                            },
                            csi: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                nodePublishSecretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeAttributes: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            downwardAPI: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      fieldRef: {
                                        properties: {
                                          apiVersion: {
                                            type: 'string',
                                          },
                                          fieldPath: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'fieldPath',
                                        ],
                                        type: 'object',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                      resourceFieldRef: {
                                        properties: {
                                          containerName: {
                                            type: 'string',
                                          },
                                          divisor: {
                                            type: 'string',
                                          },
                                          resource: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'resource',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            emptyDir: {
                              properties: {
                                medium: {
                                  type: 'string',
                                },
                                sizeLimit: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            fc: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                targetWWNs: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                wwids: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            flexVolume: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                options: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            flocker: {
                              properties: {
                                datasetName: {
                                  type: 'string',
                                },
                                datasetUUID: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            gcePersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                pdName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'pdName',
                              ],
                              type: 'object',
                            },
                            gitRepo: {
                              properties: {
                                directory: {
                                  type: 'string',
                                },
                                repository: {
                                  type: 'string',
                                },
                                revision: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'repository',
                              ],
                              type: 'object',
                            },
                            glusterfs: {
                              properties: {
                                endpoints: {
                                  type: 'string',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'endpoints',
                                'path',
                              ],
                              type: 'object',
                            },
                            hostPath: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                type: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                              ],
                              type: 'object',
                            },
                            iscsi: {
                              properties: {
                                chapAuthDiscovery: {
                                  type: 'boolean',
                                },
                                chapAuthSession: {
                                  type: 'boolean',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                initiatorName: {
                                  type: 'string',
                                },
                                iqn: {
                                  type: 'string',
                                },
                                iscsiInterface: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                portals: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                targetPortal: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'iqn',
                                'lun',
                                'targetPortal',
                              ],
                              type: 'object',
                            },
                            name: {
                              type: 'string',
                            },
                            nfs: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                server: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                                'server',
                              ],
                              type: 'object',
                            },
                            persistentVolumeClaim: {
                              properties: {
                                claimName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'claimName',
                              ],
                              type: 'object',
                            },
                            photonPersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                pdID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'pdID',
                              ],
                              type: 'object',
                            },
                            portworxVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            projected: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                sources: {
                                  items: {
                                    properties: {
                                      configMap: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      downwardAPI: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                fieldRef: {
                                                  properties: {
                                                    apiVersion: {
                                                      type: 'string',
                                                    },
                                                    fieldPath: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'fieldPath',
                                                  ],
                                                  type: 'object',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                                resourceFieldRef: {
                                                  properties: {
                                                    containerName: {
                                                      type: 'string',
                                                    },
                                                    divisor: {
                                                      type: 'string',
                                                    },
                                                    resource: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'resource',
                                                  ],
                                                  type: 'object',
                                                },
                                              },
                                              required: [
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      secret: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      serviceAccountToken: {
                                        properties: {
                                          audience: {
                                            type: 'string',
                                          },
                                          expirationSeconds: {
                                            format: 'int64',
                                            type: 'integer',
                                          },
                                          path: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'path',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              required: [
                                'sources',
                              ],
                              type: 'object',
                            },
                            quobyte: {
                              properties: {
                                group: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                registry: {
                                  type: 'string',
                                },
                                tenant: {
                                  type: 'string',
                                },
                                user: {
                                  type: 'string',
                                },
                                volume: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'registry',
                                'volume',
                              ],
                              type: 'object',
                            },
                            rbd: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                image: {
                                  type: 'string',
                                },
                                keyring: {
                                  type: 'string',
                                },
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                pool: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'image',
                                'monitors',
                              ],
                              type: 'object',
                            },
                            scaleIO: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                gateway: {
                                  type: 'string',
                                },
                                protectionDomain: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                sslEnabled: {
                                  type: 'boolean',
                                },
                                storageMode: {
                                  type: 'string',
                                },
                                storagePool: {
                                  type: 'string',
                                },
                                system: {
                                  type: 'string',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'gateway',
                                'secretRef',
                                'system',
                              ],
                              type: 'object',
                            },
                            secret: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            storageos: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                                volumeNamespace: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            vsphereVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                storagePolicyID: {
                                  type: 'string',
                                },
                                storagePolicyName: {
                                  type: 'string',
                                },
                                volumePath: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumePath',
                              ],
                              type: 'object',
                            },
                          },
                          required: [
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                  esRollover: {
                    properties: {
                      affinity: {
                        properties: {
                          nodeAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    preference: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'preference',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                properties: {
                                  nodeSelectorTerms: {
                                    items: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchFields: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                },
                                required: [
                                  'nodeSelectorTerms',
                                ],
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          podAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          podAntiAffinity: {
                            properties: {
                              preferredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    podAffinityTerm: {
                                      properties: {
                                        labelSelector: {
                                          properties: {
                                            matchExpressions: {
                                              items: {
                                                properties: {
                                                  key: {
                                                    type: 'string',
                                                  },
                                                  operator: {
                                                    type: 'string',
                                                  },
                                                  values: {
                                                    items: {
                                                      type: 'string',
                                                    },
                                                    type: 'array',
                                                  },
                                                },
                                                required: [
                                                  'key',
                                                  'operator',
                                                ],
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
                                              additionalProperties: {
                                                type: 'string',
                                              },
                                              type: 'object',
                                            },
                                          },
                                          type: 'object',
                                        },
                                        namespaces: {
                                          items: {
                                            type: 'string',
                                          },
                                          type: 'array',
                                        },
                                        topologyKey: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'topologyKey',
                                      ],
                                      type: 'object',
                                    },
                                    weight: {
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                  },
                                  required: [
                                    'podAffinityTerm',
                                    'weight',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              requiredDuringSchedulingIgnoredDuringExecution: {
                                items: {
                                  properties: {
                                    labelSelector: {
                                      properties: {
                                        matchExpressions: {
                                          items: {
                                            properties: {
                                              key: {
                                                type: 'string',
                                              },
                                              operator: {
                                                type: 'string',
                                              },
                                              values: {
                                                items: {
                                                  type: 'string',
                                                },
                                                type: 'array',
                                              },
                                            },
                                            required: [
                                              'key',
                                              'operator',
                                            ],
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
                                          additionalProperties: {
                                            type: 'string',
                                          },
                                          type: 'object',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    namespaces: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                    topologyKey: {
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'topologyKey',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      annotations: {
                        additionalProperties: {
                          type: 'string',
                        },
                        nullable: true,
                        type: 'object',
                      },
                      conditions: {
                        type: 'string',
                      },
                      image: {
                        type: 'string',
                      },
                      labels: {
                        additionalProperties: {
                          type: 'string',
                        },
                        type: 'object',
                      },
                      readTTL: {
                        type: 'string',
                      },
                      resources: {
                        nullable: true,
                        properties: {
                          limits: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                          requests: {
                            additionalProperties: {
                              type: 'string',
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      schedule: {
                        type: 'string',
                      },
                      securityContext: {
                        properties: {
                          fsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          fsGroupChangePolicy: {
                            type: 'string',
                          },
                          runAsGroup: {
                            format: 'int64',
                            type: 'integer',
                          },
                          runAsNonRoot: {
                            type: 'boolean',
                          },
                          runAsUser: {
                            format: 'int64',
                            type: 'integer',
                          },
                          seLinuxOptions: {
                            properties: {
                              level: {
                                type: 'string',
                              },
                              role: {
                                type: 'string',
                              },
                              type: {
                                type: 'string',
                              },
                              user: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          supplementalGroups: {
                            items: {
                              format: 'int64',
                              type: 'integer',
                            },
                            type: 'array',
                          },
                          sysctls: {
                            items: {
                              properties: {
                                name: {
                                  type: 'string',
                                },
                                value: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'name',
                                'value',
                              ],
                              type: 'object',
                            },
                            type: 'array',
                          },
                          windowsOptions: {
                            properties: {
                              gmsaCredentialSpec: {
                                type: 'string',
                              },
                              gmsaCredentialSpecName: {
                                type: 'string',
                              },
                              runAsUserName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      serviceAccount: {
                        type: 'string',
                      },
                      successfulJobsHistoryLimit: {
                        format: 'int32',
                        type: 'integer',
                      },
                      tolerations: {
                        items: {
                          properties: {
                            effect: {
                              type: 'string',
                            },
                            key: {
                              type: 'string',
                            },
                            operator: {
                              type: 'string',
                            },
                            tolerationSeconds: {
                              format: 'int64',
                              type: 'integer',
                            },
                            value: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      ttlSecondsAfterFinished: {
                        format: 'int32',
                        type: 'integer',
                      },
                      volumeMounts: {
                        items: {
                          properties: {
                            mountPath: {
                              type: 'string',
                            },
                            mountPropagation: {
                              type: 'string',
                            },
                            name: {
                              type: 'string',
                            },
                            readOnly: {
                              type: 'boolean',
                            },
                            subPath: {
                              type: 'string',
                            },
                            subPathExpr: {
                              type: 'string',
                            },
                          },
                          required: [
                            'mountPath',
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      volumes: {
                        items: {
                          properties: {
                            awsElasticBlockStore: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            azureDisk: {
                              properties: {
                                cachingMode: {
                                  type: 'string',
                                },
                                diskName: {
                                  type: 'string',
                                },
                                diskURI: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                kind: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'diskName',
                                'diskURI',
                              ],
                              type: 'object',
                            },
                            azureFile: {
                              properties: {
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                                shareName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'secretName',
                                'shareName',
                              ],
                              type: 'object',
                            },
                            cephfs: {
                              properties: {
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretFile: {
                                  type: 'string',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'monitors',
                              ],
                              type: 'object',
                            },
                            cinder: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            configMap: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                name: {
                                  type: 'string',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                              },
                              type: 'object',
                            },
                            csi: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                nodePublishSecretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeAttributes: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            downwardAPI: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      fieldRef: {
                                        properties: {
                                          apiVersion: {
                                            type: 'string',
                                          },
                                          fieldPath: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'fieldPath',
                                        ],
                                        type: 'object',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                      resourceFieldRef: {
                                        properties: {
                                          containerName: {
                                            type: 'string',
                                          },
                                          divisor: {
                                            type: 'string',
                                          },
                                          resource: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'resource',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    required: [
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            emptyDir: {
                              properties: {
                                medium: {
                                  type: 'string',
                                },
                                sizeLimit: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            fc: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                targetWWNs: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                wwids: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            flexVolume: {
                              properties: {
                                driver: {
                                  type: 'string',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                options: {
                                  additionalProperties: {
                                    type: 'string',
                                  },
                                  type: 'object',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                              },
                              required: [
                                'driver',
                              ],
                              type: 'object',
                            },
                            flocker: {
                              properties: {
                                datasetName: {
                                  type: 'string',
                                },
                                datasetUUID: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            gcePersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                partition: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                pdName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'pdName',
                              ],
                              type: 'object',
                            },
                            gitRepo: {
                              properties: {
                                directory: {
                                  type: 'string',
                                },
                                repository: {
                                  type: 'string',
                                },
                                revision: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'repository',
                              ],
                              type: 'object',
                            },
                            glusterfs: {
                              properties: {
                                endpoints: {
                                  type: 'string',
                                },
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'endpoints',
                                'path',
                              ],
                              type: 'object',
                            },
                            hostPath: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                type: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                              ],
                              type: 'object',
                            },
                            iscsi: {
                              properties: {
                                chapAuthDiscovery: {
                                  type: 'boolean',
                                },
                                chapAuthSession: {
                                  type: 'boolean',
                                },
                                fsType: {
                                  type: 'string',
                                },
                                initiatorName: {
                                  type: 'string',
                                },
                                iqn: {
                                  type: 'string',
                                },
                                iscsiInterface: {
                                  type: 'string',
                                },
                                lun: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                portals: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                targetPortal: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'iqn',
                                'lun',
                                'targetPortal',
                              ],
                              type: 'object',
                            },
                            name: {
                              type: 'string',
                            },
                            nfs: {
                              properties: {
                                path: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                server: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'path',
                                'server',
                              ],
                              type: 'object',
                            },
                            persistentVolumeClaim: {
                              properties: {
                                claimName: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                              },
                              required: [
                                'claimName',
                              ],
                              type: 'object',
                            },
                            photonPersistentDisk: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                pdID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'pdID',
                              ],
                              type: 'object',
                            },
                            portworxVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                volumeID: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumeID',
                              ],
                              type: 'object',
                            },
                            projected: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                sources: {
                                  items: {
                                    properties: {
                                      configMap: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      downwardAPI: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                fieldRef: {
                                                  properties: {
                                                    apiVersion: {
                                                      type: 'string',
                                                    },
                                                    fieldPath: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'fieldPath',
                                                  ],
                                                  type: 'object',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                                resourceFieldRef: {
                                                  properties: {
                                                    containerName: {
                                                      type: 'string',
                                                    },
                                                    divisor: {
                                                      type: 'string',
                                                    },
                                                    resource: {
                                                      type: 'string',
                                                    },
                                                  },
                                                  required: [
                                                    'resource',
                                                  ],
                                                  type: 'object',
                                                },
                                              },
                                              required: [
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      secret: {
                                        properties: {
                                          items: {
                                            items: {
                                              properties: {
                                                key: {
                                                  type: 'string',
                                                },
                                                mode: {
                                                  format: 'int32',
                                                  type: 'integer',
                                                },
                                                path: {
                                                  type: 'string',
                                                },
                                              },
                                              required: [
                                                'key',
                                                'path',
                                              ],
                                              type: 'object',
                                            },
                                            type: 'array',
                                          },
                                          name: {
                                            type: 'string',
                                          },
                                          optional: {
                                            type: 'boolean',
                                          },
                                        },
                                        type: 'object',
                                      },
                                      serviceAccountToken: {
                                        properties: {
                                          audience: {
                                            type: 'string',
                                          },
                                          expirationSeconds: {
                                            format: 'int64',
                                            type: 'integer',
                                          },
                                          path: {
                                            type: 'string',
                                          },
                                        },
                                        required: [
                                          'path',
                                        ],
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              required: [
                                'sources',
                              ],
                              type: 'object',
                            },
                            quobyte: {
                              properties: {
                                group: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                registry: {
                                  type: 'string',
                                },
                                tenant: {
                                  type: 'string',
                                },
                                user: {
                                  type: 'string',
                                },
                                volume: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'registry',
                                'volume',
                              ],
                              type: 'object',
                            },
                            rbd: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                image: {
                                  type: 'string',
                                },
                                keyring: {
                                  type: 'string',
                                },
                                monitors: {
                                  items: {
                                    type: 'string',
                                  },
                                  type: 'array',
                                },
                                pool: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                user: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'image',
                                'monitors',
                              ],
                              type: 'object',
                            },
                            scaleIO: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                gateway: {
                                  type: 'string',
                                },
                                protectionDomain: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                sslEnabled: {
                                  type: 'boolean',
                                },
                                storageMode: {
                                  type: 'string',
                                },
                                storagePool: {
                                  type: 'string',
                                },
                                system: {
                                  type: 'string',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'gateway',
                                'secretRef',
                                'system',
                              ],
                              type: 'object',
                            },
                            secret: {
                              properties: {
                                defaultMode: {
                                  format: 'int32',
                                  type: 'integer',
                                },
                                items: {
                                  items: {
                                    properties: {
                                      key: {
                                        type: 'string',
                                      },
                                      mode: {
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                      path: {
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'key',
                                      'path',
                                    ],
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                optional: {
                                  type: 'boolean',
                                },
                                secretName: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            storageos: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                readOnly: {
                                  type: 'boolean',
                                },
                                secretRef: {
                                  properties: {
                                    name: {
                                      type: 'string',
                                    },
                                  },
                                  type: 'object',
                                },
                                volumeName: {
                                  type: 'string',
                                },
                                volumeNamespace: {
                                  type: 'string',
                                },
                              },
                              type: 'object',
                            },
                            vsphereVolume: {
                              properties: {
                                fsType: {
                                  type: 'string',
                                },
                                storagePolicyID: {
                                  type: 'string',
                                },
                                storagePolicyName: {
                                  type: 'string',
                                },
                                volumePath: {
                                  type: 'string',
                                },
                              },
                              required: [
                                'volumePath',
                              ],
                              type: 'object',
                            },
                          },
                          required: [
                            'name',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                  options: {
                    type: 'object',
                  },
                  secretName: {
                    type: 'string',
                  },
                  type: {
                    type: 'string',
                  },
                },
                type: 'object',
              },
              strategy: {
                type: 'string',
              },
              tolerations: {
                items: {
                  properties: {
                    effect: {
                      type: 'string',
                    },
                    key: {
                      type: 'string',
                    },
                    operator: {
                      type: 'string',
                    },
                    tolerationSeconds: {
                      format: 'int64',
                      type: 'integer',
                    },
                    value: {
                      type: 'string',
                    },
                  },
                  type: 'object',
                },
                type: 'array',
              },
              ui: {
                properties: {
                  options: {
                    type: 'object',
                  },
                },
                type: 'object',
              },
              volumeMounts: {
                items: {
                  properties: {
                    mountPath: {
                      type: 'string',
                    },
                    mountPropagation: {
                      type: 'string',
                    },
                    name: {
                      type: 'string',
                    },
                    readOnly: {
                      type: 'boolean',
                    },
                    subPath: {
                      type: 'string',
                    },
                    subPathExpr: {
                      type: 'string',
                    },
                  },
                  required: [
                    'mountPath',
                    'name',
                  ],
                  type: 'object',
                },
                type: 'array',
              },
              volumes: {
                items: {
                  properties: {
                    awsElasticBlockStore: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        partition: {
                          format: 'int32',
                          type: 'integer',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        volumeID: {
                          type: 'string',
                        },
                      },
                      required: [
                        'volumeID',
                      ],
                      type: 'object',
                    },
                    azureDisk: {
                      properties: {
                        cachingMode: {
                          type: 'string',
                        },
                        diskName: {
                          type: 'string',
                        },
                        diskURI: {
                          type: 'string',
                        },
                        fsType: {
                          type: 'string',
                        },
                        kind: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                      },
                      required: [
                        'diskName',
                        'diskURI',
                      ],
                      type: 'object',
                    },
                    azureFile: {
                      properties: {
                        readOnly: {
                          type: 'boolean',
                        },
                        secretName: {
                          type: 'string',
                        },
                        shareName: {
                          type: 'string',
                        },
                      },
                      required: [
                        'secretName',
                        'shareName',
                      ],
                      type: 'object',
                    },
                    cephfs: {
                      properties: {
                        monitors: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        path: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretFile: {
                          type: 'string',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        user: {
                          type: 'string',
                        },
                      },
                      required: [
                        'monitors',
                      ],
                      type: 'object',
                    },
                    cinder: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        volumeID: {
                          type: 'string',
                        },
                      },
                      required: [
                        'volumeID',
                      ],
                      type: 'object',
                    },
                    configMap: {
                      properties: {
                        defaultMode: {
                          format: 'int32',
                          type: 'integer',
                        },
                        items: {
                          items: {
                            properties: {
                              key: {
                                type: 'string',
                              },
                              mode: {
                                format: 'int32',
                                type: 'integer',
                              },
                              path: {
                                type: 'string',
                              },
                            },
                            required: [
                              'key',
                              'path',
                            ],
                            type: 'object',
                          },
                          type: 'array',
                        },
                        name: {
                          type: 'string',
                        },
                        optional: {
                          type: 'boolean',
                        },
                      },
                      type: 'object',
                    },
                    csi: {
                      properties: {
                        driver: {
                          type: 'string',
                        },
                        fsType: {
                          type: 'string',
                        },
                        nodePublishSecretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        volumeAttributes: {
                          additionalProperties: {
                            type: 'string',
                          },
                          type: 'object',
                        },
                      },
                      required: [
                        'driver',
                      ],
                      type: 'object',
                    },
                    downwardAPI: {
                      properties: {
                        defaultMode: {
                          format: 'int32',
                          type: 'integer',
                        },
                        items: {
                          items: {
                            properties: {
                              fieldRef: {
                                properties: {
                                  apiVersion: {
                                    type: 'string',
                                  },
                                  fieldPath: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'fieldPath',
                                ],
                                type: 'object',
                              },
                              mode: {
                                format: 'int32',
                                type: 'integer',
                              },
                              path: {
                                type: 'string',
                              },
                              resourceFieldRef: {
                                properties: {
                                  containerName: {
                                    type: 'string',
                                  },
                                  divisor: {
                                    type: 'string',
                                  },
                                  resource: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'resource',
                                ],
                                type: 'object',
                              },
                            },
                            required: [
                              'path',
                            ],
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    emptyDir: {
                      properties: {
                        medium: {
                          type: 'string',
                        },
                        sizeLimit: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    fc: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        lun: {
                          format: 'int32',
                          type: 'integer',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        targetWWNs: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        wwids: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                      },
                      type: 'object',
                    },
                    flexVolume: {
                      properties: {
                        driver: {
                          type: 'string',
                        },
                        fsType: {
                          type: 'string',
                        },
                        options: {
                          additionalProperties: {
                            type: 'string',
                          },
                          type: 'object',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                      },
                      required: [
                        'driver',
                      ],
                      type: 'object',
                    },
                    flocker: {
                      properties: {
                        datasetName: {
                          type: 'string',
                        },
                        datasetUUID: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    gcePersistentDisk: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        partition: {
                          format: 'int32',
                          type: 'integer',
                        },
                        pdName: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                      },
                      required: [
                        'pdName',
                      ],
                      type: 'object',
                    },
                    gitRepo: {
                      properties: {
                        directory: {
                          type: 'string',
                        },
                        repository: {
                          type: 'string',
                        },
                        revision: {
                          type: 'string',
                        },
                      },
                      required: [
                        'repository',
                      ],
                      type: 'object',
                    },
                    glusterfs: {
                      properties: {
                        endpoints: {
                          type: 'string',
                        },
                        path: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                      },
                      required: [
                        'endpoints',
                        'path',
                      ],
                      type: 'object',
                    },
                    hostPath: {
                      properties: {
                        path: {
                          type: 'string',
                        },
                        type: {
                          type: 'string',
                        },
                      },
                      required: [
                        'path',
                      ],
                      type: 'object',
                    },
                    iscsi: {
                      properties: {
                        chapAuthDiscovery: {
                          type: 'boolean',
                        },
                        chapAuthSession: {
                          type: 'boolean',
                        },
                        fsType: {
                          type: 'string',
                        },
                        initiatorName: {
                          type: 'string',
                        },
                        iqn: {
                          type: 'string',
                        },
                        iscsiInterface: {
                          type: 'string',
                        },
                        lun: {
                          format: 'int32',
                          type: 'integer',
                        },
                        portals: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        targetPortal: {
                          type: 'string',
                        },
                      },
                      required: [
                        'iqn',
                        'lun',
                        'targetPortal',
                      ],
                      type: 'object',
                    },
                    name: {
                      type: 'string',
                    },
                    nfs: {
                      properties: {
                        path: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        server: {
                          type: 'string',
                        },
                      },
                      required: [
                        'path',
                        'server',
                      ],
                      type: 'object',
                    },
                    persistentVolumeClaim: {
                      properties: {
                        claimName: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                      },
                      required: [
                        'claimName',
                      ],
                      type: 'object',
                    },
                    photonPersistentDisk: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        pdID: {
                          type: 'string',
                        },
                      },
                      required: [
                        'pdID',
                      ],
                      type: 'object',
                    },
                    portworxVolume: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        volumeID: {
                          type: 'string',
                        },
                      },
                      required: [
                        'volumeID',
                      ],
                      type: 'object',
                    },
                    projected: {
                      properties: {
                        defaultMode: {
                          format: 'int32',
                          type: 'integer',
                        },
                        sources: {
                          items: {
                            properties: {
                              configMap: {
                                properties: {
                                  items: {
                                    items: {
                                      properties: {
                                        key: {
                                          type: 'string',
                                        },
                                        mode: {
                                          format: 'int32',
                                          type: 'integer',
                                        },
                                        path: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'path',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  name: {
                                    type: 'string',
                                  },
                                  optional: {
                                    type: 'boolean',
                                  },
                                },
                                type: 'object',
                              },
                              downwardAPI: {
                                properties: {
                                  items: {
                                    items: {
                                      properties: {
                                        fieldRef: {
                                          properties: {
                                            apiVersion: {
                                              type: 'string',
                                            },
                                            fieldPath: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'fieldPath',
                                          ],
                                          type: 'object',
                                        },
                                        mode: {
                                          format: 'int32',
                                          type: 'integer',
                                        },
                                        path: {
                                          type: 'string',
                                        },
                                        resourceFieldRef: {
                                          properties: {
                                            containerName: {
                                              type: 'string',
                                            },
                                            divisor: {
                                              type: 'string',
                                            },
                                            resource: {
                                              type: 'string',
                                            },
                                          },
                                          required: [
                                            'resource',
                                          ],
                                          type: 'object',
                                        },
                                      },
                                      required: [
                                        'path',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                },
                                type: 'object',
                              },
                              secret: {
                                properties: {
                                  items: {
                                    items: {
                                      properties: {
                                        key: {
                                          type: 'string',
                                        },
                                        mode: {
                                          format: 'int32',
                                          type: 'integer',
                                        },
                                        path: {
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'key',
                                        'path',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  name: {
                                    type: 'string',
                                  },
                                  optional: {
                                    type: 'boolean',
                                  },
                                },
                                type: 'object',
                              },
                              serviceAccountToken: {
                                properties: {
                                  audience: {
                                    type: 'string',
                                  },
                                  expirationSeconds: {
                                    format: 'int64',
                                    type: 'integer',
                                  },
                                  path: {
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'path',
                                ],
                                type: 'object',
                              },
                            },
                            type: 'object',
                          },
                          type: 'array',
                        },
                      },
                      required: [
                        'sources',
                      ],
                      type: 'object',
                    },
                    quobyte: {
                      properties: {
                        group: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        registry: {
                          type: 'string',
                        },
                        tenant: {
                          type: 'string',
                        },
                        user: {
                          type: 'string',
                        },
                        volume: {
                          type: 'string',
                        },
                      },
                      required: [
                        'registry',
                        'volume',
                      ],
                      type: 'object',
                    },
                    rbd: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        image: {
                          type: 'string',
                        },
                        keyring: {
                          type: 'string',
                        },
                        monitors: {
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        pool: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        user: {
                          type: 'string',
                        },
                      },
                      required: [
                        'image',
                        'monitors',
                      ],
                      type: 'object',
                    },
                    scaleIO: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        gateway: {
                          type: 'string',
                        },
                        protectionDomain: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        sslEnabled: {
                          type: 'boolean',
                        },
                        storageMode: {
                          type: 'string',
                        },
                        storagePool: {
                          type: 'string',
                        },
                        system: {
                          type: 'string',
                        },
                        volumeName: {
                          type: 'string',
                        },
                      },
                      required: [
                        'gateway',
                        'secretRef',
                        'system',
                      ],
                      type: 'object',
                    },
                    secret: {
                      properties: {
                        defaultMode: {
                          format: 'int32',
                          type: 'integer',
                        },
                        items: {
                          items: {
                            properties: {
                              key: {
                                type: 'string',
                              },
                              mode: {
                                format: 'int32',
                                type: 'integer',
                              },
                              path: {
                                type: 'string',
                              },
                            },
                            required: [
                              'key',
                              'path',
                            ],
                            type: 'object',
                          },
                          type: 'array',
                        },
                        optional: {
                          type: 'boolean',
                        },
                        secretName: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    storageos: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        readOnly: {
                          type: 'boolean',
                        },
                        secretRef: {
                          properties: {
                            name: {
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        volumeName: {
                          type: 'string',
                        },
                        volumeNamespace: {
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    vsphereVolume: {
                      properties: {
                        fsType: {
                          type: 'string',
                        },
                        storagePolicyID: {
                          type: 'string',
                        },
                        storagePolicyName: {
                          type: 'string',
                        },
                        volumePath: {
                          type: 'string',
                        },
                      },
                      required: [
                        'volumePath',
                      ],
                      type: 'object',
                    },
                  },
                  required: [
                    'name',
                  ],
                  type: 'object',
                },
                type: 'array',
              },
            },
            type: 'object',
          },
          status: {
            properties: {
              phase: {
                type: 'string',
              },
              version: {
                type: 'string',
              },
            },
            required: [
              'phase',
              'version',
            ],
            type: 'object',
          },
        },
        type: 'object',
      },
    },
    version: 'v1',
    versions: [
      {
        name: 'v1',
        served: true,
        storage: true,
      },
    ],
  },
  status: {
    acceptedNames: {
      kind: '',
      plural: '',
    },
    conditions: [],
    storedVersions: [],
  },
}
