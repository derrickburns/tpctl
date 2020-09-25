{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkamirrormakers.kafka.strimzi.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.spec.replicas',
        description: 'The desired number of Kafka MirrorMaker replicas',
        name: 'Desired replicas',
        type: 'integer',
      },
      {
        JSONPath: '.spec.consumer.bootstrapServers',
        description: 'The boostrap servers for the consumer',
        name: 'Consumer Bootstrap Servers',
        priority: 1,
        type: 'string',
      },
      {
        JSONPath: '.spec.producer.bootstrapServers',
        description: 'The boostrap servers for the producer',
        name: 'Producer Bootstrap Servers',
        priority: 1,
        type: 'string',
      },
    ],
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'KafkaMirrorMaker',
      listKind: 'KafkaMirrorMakerList',
      plural: 'kafkamirrormakers',
      shortNames: [
        'kmm',
      ],
      singular: 'kafkamirrormaker',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of Kafka MirrorMaker.',
            properties: {
              affinity: {
                description: "The pod's affinity rules.",
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
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                              },
                              type: 'object',
                            },
                            weight: {
                              type: 'integer',
                            },
                          },
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
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
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
                              type: 'object',
                            },
                            weight: {
                              type: 'integer',
                            },
                          },
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
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchLabels: {
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
                                        type: 'object',
                                      },
                                      type: 'array',
                                    },
                                    matchLabels: {
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
                              type: 'object',
                            },
                            weight: {
                              type: 'integer',
                            },
                          },
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
                                    type: 'object',
                                  },
                                  type: 'array',
                                },
                                matchLabels: {
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
              consumer: {
                description: 'Configuration of source cluster.',
                properties: {
                  authentication: {
                    description: 'Authentication configuration for connecting to the cluster.',
                    properties: {
                      accessToken: {
                        description: 'Link to Kubernetes Secret containing the access token which was obtained from the authorization server.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      accessTokenIsJwt: {
                        description: 'Configure whether access token should be treated as JWT. This should be set to `false` if the authorization server returns opaque tokens. Defaults to `true`.',
                        type: 'boolean',
                      },
                      certificateAndKey: {
                        description: 'Reference to the `Secret` which holds the certificate and private key pair.',
                        properties: {
                          certificate: {
                            description: 'The name of the file certificate in the Secret.',
                            type: 'string',
                          },
                          key: {
                            description: 'The name of the private key in the Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Secret containing the certificate.',
                            type: 'string',
                          },
                        },
                        required: [
                          'certificate',
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      clientId: {
                        description: 'OAuth Client ID which the Kafka client can use to authenticate against the OAuth server and use the token endpoint URI.',
                        type: 'string',
                      },
                      clientSecret: {
                        description: 'Link to Kubernetes Secret containing the OAuth client secret which the Kafka client can use to authenticate against the OAuth server and use the token endpoint URI.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      disableTlsHostnameVerification: {
                        description: 'Enable or disable TLS hostname verification. Default value is `false`.',
                        type: 'boolean',
                      },
                      maxTokenExpirySeconds: {
                        description: 'Set or limit time-to-live of the access tokens to the specified number of seconds. This should be set if the authorization server returns opaque tokens.',
                        type: 'integer',
                      },
                      passwordSecret: {
                        description: 'Reference to the `Secret` which holds the password.',
                        properties: {
                          password: {
                            description: 'The name of the key in the Secret under which the password is stored.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Secret containing the password.',
                            type: 'string',
                          },
                        },
                        required: [
                          'password',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      refreshToken: {
                        description: 'Link to Kubernetes Secret containing the refresh token which can be used to obtain access token from the authorization server.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      scope: {
                        description: 'OAuth scope to use when authenticating against the authorization server. Some authorization servers require this to be set. The possible values depend on how authorization server is configured. By default `scope` is not specified when doing the token endpoint request.',
                        type: 'string',
                      },
                      tlsTrustedCertificates: {
                        description: 'Trusted certificates for TLS connection to the OAuth server.',
                        items: {
                          properties: {
                            certificate: {
                              description: 'The name of the file certificate in the Secret.',
                              type: 'string',
                            },
                            secretName: {
                              description: 'The name of the Secret containing the certificate.',
                              type: 'string',
                            },
                          },
                          required: [
                            'certificate',
                            'secretName',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      tokenEndpointUri: {
                        description: 'Authorization server token endpoint URI.',
                        type: 'string',
                      },
                      type: {
                        description: 'Authentication type. Currently the only supported types are `tls`, `scram-sha-512`, and `plain`. `scram-sha-512` type uses SASL SCRAM-SHA-512 Authentication. `plain` type uses SASL PLAIN Authentication. `oauth` type uses SASL OAUTHBEARER Authentication. The `tls` type uses TLS Client Authentication. The `tls` type is supported only over TLS connections.',
                        enum: [
                          'tls',
                          'scram-sha-512',
                          'plain',
                          'oauth',
                        ],
                        type: 'string',
                      },
                      username: {
                        description: 'Username used for the authentication.',
                        type: 'string',
                      },
                    },
                    required: [
                      'type',
                    ],
                    type: 'object',
                  },
                  bootstrapServers: {
                    description: 'A list of host:port pairs for establishing the initial connection to the Kafka cluster.',
                    type: 'string',
                  },
                  config: {
                    description: 'The MirrorMaker consumer config. Properties with the following prefixes cannot be set: ssl., bootstrap.servers, group.id, sasl., security., interceptor.classes (with the exception of: ssl.endpoint.identification.algorithm, ssl.cipher.suites, ssl.protocol, ssl.enabled.protocols).',
                    type: 'object',
                  },
                  groupId: {
                    description: 'A unique string that identifies the consumer group this consumer belongs to.',
                    type: 'string',
                  },
                  numStreams: {
                    description: 'Specifies the number of consumer stream threads to create.',
                    minimum: 1,
                    type: 'integer',
                  },
                  offsetCommitInterval: {
                    description: 'Specifies the offset auto-commit interval in ms. Default value is 60000.',
                    type: 'integer',
                  },
                  tls: {
                    description: 'TLS configuration for connecting MirrorMaker to the cluster.',
                    properties: {
                      trustedCertificates: {
                        description: 'Trusted certificates for TLS connection.',
                        items: {
                          properties: {
                            certificate: {
                              description: 'The name of the file certificate in the Secret.',
                              type: 'string',
                            },
                            secretName: {
                              description: 'The name of the Secret containing the certificate.',
                              type: 'string',
                            },
                          },
                          required: [
                            'certificate',
                            'secretName',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                },
                required: [
                  'groupId',
                  'bootstrapServers',
                ],
                type: 'object',
              },
              image: {
                description: 'The docker image for the pods.',
                type: 'string',
              },
              jvmOptions: {
                description: 'JVM Options for pods.',
                properties: {
                  '-XX': {
                    description: 'A map of -XX options to the JVM.',
                    type: 'object',
                  },
                  '-Xms': {
                    description: '-Xms option to to the JVM.',
                    pattern: '[0-9]+[mMgG]?',
                    type: 'string',
                  },
                  '-Xmx': {
                    description: '-Xmx option to to the JVM.',
                    pattern: '[0-9]+[mMgG]?',
                    type: 'string',
                  },
                  gcLoggingEnabled: {
                    description: 'Specifies whether the Garbage Collection logging is enabled. The default is false.',
                    type: 'boolean',
                  },
                  javaSystemProperties: {
                    description: 'A map of additional system properties which will be passed using the `-D` option to the JVM.',
                    items: {
                      properties: {
                        name: {
                          description: 'The system property name.',
                          type: 'string',
                        },
                        value: {
                          description: 'The system property value.',
                          type: 'string',
                        },
                      },
                      type: 'object',
                    },
                    type: 'array',
                  },
                },
                type: 'object',
              },
              livenessProbe: {
                description: 'Pod liveness checking.',
                properties: {
                  failureThreshold: {
                    description: 'Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.',
                    type: 'integer',
                  },
                  initialDelaySeconds: {
                    description: 'The initial delay before first the health is first checked.',
                    minimum: 0,
                    type: 'integer',
                  },
                  periodSeconds: {
                    description: 'How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.',
                    type: 'integer',
                  },
                  successThreshold: {
                    description: 'Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness. Minimum value is 1.',
                    type: 'integer',
                  },
                  timeoutSeconds: {
                    description: 'The timeout for each attempted health check.',
                    minimum: 0,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
              logging: {
                description: 'Logging configuration for MirrorMaker.',
                properties: {
                  loggers: {
                    description: 'A Map from logger name to logger level.',
                    type: 'object',
                  },
                  name: {
                    description: 'The name of the `ConfigMap` from which to get the logging configuration.',
                    type: 'string',
                  },
                  type: {
                    description: "Logging type, must be either 'inline' or 'external'.",
                    enum: [
                      'inline',
                      'external',
                    ],
                    type: 'string',
                  },
                },
                required: [
                  'type',
                ],
                type: 'object',
              },
              metrics: {
                description: 'The Prometheus JMX Exporter configuration. See {JMXExporter} for details of the structure of this configuration.',
                type: 'object',
              },
              producer: {
                description: 'Configuration of target cluster.',
                properties: {
                  abortOnSendFailure: {
                    description: 'Flag to set the MirrorMaker to exit on a failed send. Default value is `true`.',
                    type: 'boolean',
                  },
                  authentication: {
                    description: 'Authentication configuration for connecting to the cluster.',
                    properties: {
                      accessToken: {
                        description: 'Link to Kubernetes Secret containing the access token which was obtained from the authorization server.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      accessTokenIsJwt: {
                        description: 'Configure whether access token should be treated as JWT. This should be set to `false` if the authorization server returns opaque tokens. Defaults to `true`.',
                        type: 'boolean',
                      },
                      certificateAndKey: {
                        description: 'Reference to the `Secret` which holds the certificate and private key pair.',
                        properties: {
                          certificate: {
                            description: 'The name of the file certificate in the Secret.',
                            type: 'string',
                          },
                          key: {
                            description: 'The name of the private key in the Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Secret containing the certificate.',
                            type: 'string',
                          },
                        },
                        required: [
                          'certificate',
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      clientId: {
                        description: 'OAuth Client ID which the Kafka client can use to authenticate against the OAuth server and use the token endpoint URI.',
                        type: 'string',
                      },
                      clientSecret: {
                        description: 'Link to Kubernetes Secret containing the OAuth client secret which the Kafka client can use to authenticate against the OAuth server and use the token endpoint URI.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      disableTlsHostnameVerification: {
                        description: 'Enable or disable TLS hostname verification. Default value is `false`.',
                        type: 'boolean',
                      },
                      maxTokenExpirySeconds: {
                        description: 'Set or limit time-to-live of the access tokens to the specified number of seconds. This should be set if the authorization server returns opaque tokens.',
                        type: 'integer',
                      },
                      passwordSecret: {
                        description: 'Reference to the `Secret` which holds the password.',
                        properties: {
                          password: {
                            description: 'The name of the key in the Secret under which the password is stored.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Secret containing the password.',
                            type: 'string',
                          },
                        },
                        required: [
                          'password',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      refreshToken: {
                        description: 'Link to Kubernetes Secret containing the refresh token which can be used to obtain access token from the authorization server.',
                        properties: {
                          key: {
                            description: 'The key under which the secret value is stored in the Kubernetes Secret.',
                            type: 'string',
                          },
                          secretName: {
                            description: 'The name of the Kubernetes Secret containing the secret value.',
                            type: 'string',
                          },
                        },
                        required: [
                          'key',
                          'secretName',
                        ],
                        type: 'object',
                      },
                      scope: {
                        description: 'OAuth scope to use when authenticating against the authorization server. Some authorization servers require this to be set. The possible values depend on how authorization server is configured. By default `scope` is not specified when doing the token endpoint request.',
                        type: 'string',
                      },
                      tlsTrustedCertificates: {
                        description: 'Trusted certificates for TLS connection to the OAuth server.',
                        items: {
                          properties: {
                            certificate: {
                              description: 'The name of the file certificate in the Secret.',
                              type: 'string',
                            },
                            secretName: {
                              description: 'The name of the Secret containing the certificate.',
                              type: 'string',
                            },
                          },
                          required: [
                            'certificate',
                            'secretName',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                      tokenEndpointUri: {
                        description: 'Authorization server token endpoint URI.',
                        type: 'string',
                      },
                      type: {
                        description: 'Authentication type. Currently the only supported types are `tls`, `scram-sha-512`, and `plain`. `scram-sha-512` type uses SASL SCRAM-SHA-512 Authentication. `plain` type uses SASL PLAIN Authentication. `oauth` type uses SASL OAUTHBEARER Authentication. The `tls` type uses TLS Client Authentication. The `tls` type is supported only over TLS connections.',
                        enum: [
                          'tls',
                          'scram-sha-512',
                          'plain',
                          'oauth',
                        ],
                        type: 'string',
                      },
                      username: {
                        description: 'Username used for the authentication.',
                        type: 'string',
                      },
                    },
                    required: [
                      'type',
                    ],
                    type: 'object',
                  },
                  bootstrapServers: {
                    description: 'A list of host:port pairs for establishing the initial connection to the Kafka cluster.',
                    type: 'string',
                  },
                  config: {
                    description: 'The MirrorMaker producer config. Properties with the following prefixes cannot be set: ssl., bootstrap.servers, sasl., security., interceptor.classes (with the exception of: ssl.endpoint.identification.algorithm, ssl.cipher.suites, ssl.protocol, ssl.enabled.protocols).',
                    type: 'object',
                  },
                  tls: {
                    description: 'TLS configuration for connecting MirrorMaker to the cluster.',
                    properties: {
                      trustedCertificates: {
                        description: 'Trusted certificates for TLS connection.',
                        items: {
                          properties: {
                            certificate: {
                              description: 'The name of the file certificate in the Secret.',
                              type: 'string',
                            },
                            secretName: {
                              description: 'The name of the Secret containing the certificate.',
                              type: 'string',
                            },
                          },
                          required: [
                            'certificate',
                            'secretName',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    type: 'object',
                  },
                },
                required: [
                  'bootstrapServers',
                ],
                type: 'object',
              },
              readinessProbe: {
                description: 'Pod readiness checking.',
                properties: {
                  failureThreshold: {
                    description: 'Minimum consecutive failures for the probe to be considered failed after having succeeded. Defaults to 3. Minimum value is 1.',
                    type: 'integer',
                  },
                  initialDelaySeconds: {
                    description: 'The initial delay before first the health is first checked.',
                    minimum: 0,
                    type: 'integer',
                  },
                  periodSeconds: {
                    description: 'How often (in seconds) to perform the probe. Default to 10 seconds. Minimum value is 1.',
                    type: 'integer',
                  },
                  successThreshold: {
                    description: 'Minimum consecutive successes for the probe to be considered successful after having failed. Defaults to 1. Must be 1 for liveness. Minimum value is 1.',
                    type: 'integer',
                  },
                  timeoutSeconds: {
                    description: 'The timeout for each attempted health check.',
                    minimum: 0,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
              replicas: {
                description: 'The number of pods in the `Deployment`.',
                minimum: 1,
                type: 'integer',
              },
              resources: {
                description: 'CPU and memory resources to reserve.',
                properties: {
                  limits: {
                    type: 'object',
                  },
                  requests: {
                    type: 'object',
                  },
                },
                type: 'object',
              },
              template: {
                description: 'Template to specify how Kafka MirrorMaker resources, `Deployments` and `Pods`, are generated.',
                properties: {
                  deployment: {
                    description: 'Template for Kafka MirrorMaker `Deployment`.',
                    properties: {
                      metadata: {
                        description: 'Metadata which should be applied to the resource.',
                        properties: {
                          annotations: {
                            description: 'Annotations which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                          labels: {
                            description: 'Labels which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  mirrorMakerContainer: {
                    description: 'Template for Kafka MirrorMaker container.',
                    properties: {
                      env: {
                        description: 'Environment variables which should be applied to the container.',
                        items: {
                          properties: {
                            name: {
                              description: 'The environment variable key.',
                              type: 'string',
                            },
                            value: {
                              description: 'The environment variable value.',
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      securityContext: {
                        description: 'Security context for the container.',
                        properties: {
                          allowPrivilegeEscalation: {
                            type: 'boolean',
                          },
                          capabilities: {
                            properties: {
                              add: {
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                              drop: {
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          privileged: {
                            type: 'boolean',
                          },
                          procMount: {
                            type: 'string',
                          },
                          readOnlyRootFilesystem: {
                            type: 'boolean',
                          },
                          runAsGroup: {
                            type: 'integer',
                          },
                          runAsNonRoot: {
                            type: 'boolean',
                          },
                          runAsUser: {
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
                          windowsOptions: {
                            properties: {
                              gmsaCredentialSpec: {
                                type: 'string',
                              },
                              gmsaCredentialSpecName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  pod: {
                    description: 'Template for Kafka MirrorMaker `Pods`.',
                    properties: {
                      affinity: {
                        description: "The pod's affinity rules.",
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
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                      },
                                      type: 'object',
                                    },
                                    weight: {
                                      type: 'integer',
                                    },
                                  },
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
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
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
                                      type: 'object',
                                    },
                                    weight: {
                                      type: 'integer',
                                    },
                                  },
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
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
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
                                                type: 'object',
                                              },
                                              type: 'array',
                                            },
                                            matchLabels: {
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
                                      type: 'object',
                                    },
                                    weight: {
                                      type: 'integer',
                                    },
                                  },
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
                                            type: 'object',
                                          },
                                          type: 'array',
                                        },
                                        matchLabels: {
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
                      imagePullSecrets: {
                        description: 'List of references to secrets in the same namespace to use for pulling any of the images used by this Pod.',
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
                      metadata: {
                        description: 'Metadata applied to the resource.',
                        properties: {
                          annotations: {
                            description: 'Annotations which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                          labels: {
                            description: 'Labels which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      priorityClassName: {
                        description: 'The name of the Priority Class to which these pods will be assigned.',
                        type: 'string',
                      },
                      schedulerName: {
                        description: 'The name of the scheduler used to dispatch this `Pod`. If not specified, the default scheduler will be used.',
                        type: 'string',
                      },
                      securityContext: {
                        description: 'Configures pod-level security attributes and common container settings.',
                        properties: {
                          fsGroup: {
                            type: 'integer',
                          },
                          runAsGroup: {
                            type: 'integer',
                          },
                          runAsNonRoot: {
                            type: 'boolean',
                          },
                          runAsUser: {
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
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      terminationGracePeriodSeconds: {
                        description: 'The grace period is the duration in seconds after the processes running in the pod are sent a termination signal and the time when the processes are forcibly halted with a kill signal. Set this value longer than the expected cleanup time for your process.Value must be non-negative integer. The value zero indicates delete immediately. Defaults to 30 seconds.',
                        minimum: 0,
                        type: 'integer',
                      },
                      tolerations: {
                        description: "The pod's tolerations.",
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
                    },
                    type: 'object',
                  },
                  podDisruptionBudget: {
                    description: 'Template for Kafka MirrorMaker `PodDisruptionBudget`.',
                    properties: {
                      maxUnavailable: {
                        description: 'Maximum number of unavailable pods to allow automatic Pod eviction. A Pod eviction is allowed when the `maxUnavailable` number of pods or fewer are unavailable after the eviction. Setting this value to 0 prevents all voluntary evictions, so the pods must be evicted manually. Defaults to 1.',
                        minimum: 0,
                        type: 'integer',
                      },
                      metadata: {
                        description: 'Metadata to apply to the `PodDistruptionBugetTemplate` resource.',
                        properties: {
                          annotations: {
                            description: 'Annotations which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                          labels: {
                            description: 'Labels which should be added to the resource template. Can be applied to different resources such as `StatefulSets`, `Deployments`, `Pods`, and `Services`.',
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              tolerations: {
                description: "The pod's tolerations.",
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
              tracing: {
                description: 'The configuration of tracing in Kafka MirrorMaker.',
                properties: {
                  type: {
                    description: 'Type of the tracing used. Currently the only supported type is `jaeger` for Jaeger tracing.',
                    enum: [
                      'jaeger',
                    ],
                    type: 'string',
                  },
                },
                required: [
                  'type',
                ],
                type: 'object',
              },
              version: {
                description: 'The Kafka MirrorMaker version. Defaults to {DefaultKafkaVersion}. Consult the documentation to understand the process required to upgrade or downgrade the version.',
                type: 'string',
              },
              whitelist: {
                description: "List of topics which are included for mirroring. This option allows any regular expression using Java-style regular expressions. Mirroring two topics named A and B is achieved by using the whitelist `'A\\|B'`. Or, as a special case, you can mirror all topics using the whitelist '*'. You can also specify multiple regular expressions separated by commas.",
                type: 'string',
              },
            },
            required: [
              'replicas',
              'whitelist',
              'consumer',
              'producer',
            ],
            type: 'object',
          },
          status: {
            description: 'The status of Kafka MirrorMaker.',
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
