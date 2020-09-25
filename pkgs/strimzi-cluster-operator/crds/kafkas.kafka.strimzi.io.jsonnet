{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    labels: {
      app: 'strimzi',
      'strimzi.io/crd-install': 'true',
    },
    name: 'kafkas.kafka.strimzi.io',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.spec.kafka.replicas',
        description: 'The desired number of Kafka replicas in the cluster',
        name: 'Desired Kafka replicas',
        type: 'integer',
      },
      {
        JSONPath: '.spec.zookeeper.replicas',
        description: 'The desired number of ZooKeeper replicas in the cluster',
        name: 'Desired ZK replicas',
        type: 'integer',
      },
    ],
    group: 'kafka.strimzi.io',
    names: {
      categories: [
        'strimzi',
      ],
      kind: 'Kafka',
      listKind: 'KafkaList',
      plural: 'kafkas',
      shortNames: [
        'k',
      ],
      singular: 'kafka',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    validation: {
      openAPIV3Schema: {
        properties: {
          spec: {
            description: 'The specification of the Kafka and ZooKeeper clusters, and Topic Operator.',
            properties: {
              clientsCa: {
                description: 'Configuration of the clients certificate authority.',
                properties: {
                  certificateExpirationPolicy: {
                    description: 'How should CA certificate expiration be handled when `generateCertificateAuthority=true`. The default is for a new CA certificate to be generated reusing the existing private key.',
                    enum: [
                      'renew-certificate',
                      'replace-key',
                    ],
                    type: 'string',
                  },
                  generateCertificateAuthority: {
                    description: 'If true then Certificate Authority certificates will be generated automatically. Otherwise the user will need to provide a Secret with the CA certificate. Default is true.',
                    type: 'boolean',
                  },
                  renewalDays: {
                    description: 'The number of days in the certificate renewal period. This is the number of days before the a certificate expires during which renewal actions may be performed. When `generateCertificateAuthority` is true, this will cause the generation of a new certificate. When `generateCertificateAuthority` is true, this will cause extra logging at WARN level about the pending certificate expiry. Default is 30.',
                    minimum: 1,
                    type: 'integer',
                  },
                  validityDays: {
                    description: 'The number of days generated certificates should be valid for. The default is 365.',
                    minimum: 1,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
              clusterCa: {
                description: 'Configuration of the cluster certificate authority.',
                properties: {
                  certificateExpirationPolicy: {
                    description: 'How should CA certificate expiration be handled when `generateCertificateAuthority=true`. The default is for a new CA certificate to be generated reusing the existing private key.',
                    enum: [
                      'renew-certificate',
                      'replace-key',
                    ],
                    type: 'string',
                  },
                  generateCertificateAuthority: {
                    description: 'If true then Certificate Authority certificates will be generated automatically. Otherwise the user will need to provide a Secret with the CA certificate. Default is true.',
                    type: 'boolean',
                  },
                  renewalDays: {
                    description: 'The number of days in the certificate renewal period. This is the number of days before the a certificate expires during which renewal actions may be performed. When `generateCertificateAuthority` is true, this will cause the generation of a new certificate. When `generateCertificateAuthority` is true, this will cause extra logging at WARN level about the pending certificate expiry. Default is 30.',
                    minimum: 1,
                    type: 'integer',
                  },
                  validityDays: {
                    description: 'The number of days generated certificates should be valid for. The default is 365.',
                    minimum: 1,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
              cruiseControl: {
                description: 'Configuration for Cruise Control deployment. Deploys a Cruise Control instance when specified.',
                properties: {
                  brokerCapacity: {
                    description: 'The Cruise Control `brokerCapacity` configuration.',
                    properties: {
                      cpuUtilization: {
                        description: 'Broker capacity for CPU resource utilization as a percentage (0 - 100).',
                        maximum: 100,
                        minimum: 0,
                        type: 'integer',
                      },
                      disk: {
                        description: 'Broker capacity for disk in bytes, for example, 100Gi.',
                        pattern: '^[0-9]+([.][0-9]*)?([KMGTPE]i?|e[0-9]+)?$',
                        type: 'string',
                      },
                      inboundNetwork: {
                        description: 'Broker capacity for inbound network throughput in bytes per second, for example, 10000KB/s.',
                        pattern: '[0-9]+([KMG]i?)?B/s',
                        type: 'string',
                      },
                      outboundNetwork: {
                        description: 'Broker capacity for outbound network throughput in bytes per second, for example 10000KB/s.',
                        pattern: '[0-9]+([KMG]i?)?B/s',
                        type: 'string',
                      },
                    },
                    type: 'object',
                  },
                  config: {
                    description: 'The Cruise Control configuration. For a full list of configuration options refer to https://github.com/linkedin/cruise-control/wiki/Configurations. Note that properties with the following prefixes cannot be set: bootstrap.servers, client.id, zookeeper., network., security., failed.brokers.zk.path,webserver.http., webserver.api.urlprefix, webserver.session.path, webserver.accesslog., two.step., request.reason.required,metric.reporter.sampler.bootstrap.servers, metric.reporter.topic, partition.metric.sample.store.topic, broker.metric.sample.store.topic,capacity.config.file, self.healing., anomaly.detection., ssl.',
                    type: 'object',
                  },
                  image: {
                    description: 'The docker image for the pods.',
                    type: 'string',
                  },
                  jvmOptions: {
                    description: 'JVM Options for the Cruise Control container.',
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
                    description: 'Pod liveness checking for the Cruise Control container.',
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
                    description: 'Logging configuration (log4j1) for Cruise Control.',
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
                  readinessProbe: {
                    description: 'Pod readiness checking for the Cruise Control container.',
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
                  resources: {
                    description: 'CPU and memory resources to reserve for the Cruise Control container.',
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
                    description: 'Template to specify how Cruise Control resources, `Deployments` and `Pods`, are generated.',
                    properties: {
                      apiService: {
                        description: 'Template for Cruise Control API `Service`.',
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
                      cruiseControlContainer: {
                        description: 'Template for the Cruise Control container.',
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
                      deployment: {
                        description: 'Template for Cruise Control `Deployment`.',
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
                      pod: {
                        description: 'Template for Cruise Control `Pods`.',
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
                        description: 'Template for Cruise Control `PodDisruptionBudget`.',
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
                      tlsSidecarContainer: {
                        description: 'Template for the Cruise Control TLS sidecar container.',
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
                    },
                    type: 'object',
                  },
                  tlsSidecar: {
                    description: 'TLS sidecar configuration.',
                    properties: {
                      image: {
                        description: 'The docker image for the container.',
                        type: 'string',
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
                      logLevel: {
                        description: 'The log level for the TLS sidecar. Default value is `notice`.',
                        enum: [
                          'emerg',
                          'alert',
                          'crit',
                          'err',
                          'warning',
                          'notice',
                          'info',
                          'debug',
                        ],
                        type: 'string',
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
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              entityOperator: {
                description: 'Configuration of the Entity Operator.',
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
                  template: {
                    description: 'Template for Entity Operator resources. The template allows users to specify how is the `Deployment` and `Pods` generated.',
                    properties: {
                      deployment: {
                        description: 'Template for Entity Operator `Deployment`.',
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
                      pod: {
                        description: 'Template for Entity Operator `Pods`.',
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
                      tlsSidecarContainer: {
                        description: 'Template for the Entity Operator TLS sidecar container.',
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
                      topicOperatorContainer: {
                        description: 'Template for the Entity Topic Operator container.',
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
                      userOperatorContainer: {
                        description: 'Template for the Entity User Operator container.',
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
                    },
                    type: 'object',
                  },
                  tlsSidecar: {
                    description: 'TLS sidecar configuration.',
                    properties: {
                      image: {
                        description: 'The docker image for the container.',
                        type: 'string',
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
                      logLevel: {
                        description: 'The log level for the TLS sidecar. Default value is `notice`.',
                        enum: [
                          'emerg',
                          'alert',
                          'crit',
                          'err',
                          'warning',
                          'notice',
                          'info',
                          'debug',
                        ],
                        type: 'string',
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
                  topicOperator: {
                    description: 'Configuration of the Topic Operator.',
                    properties: {
                      image: {
                        description: 'The image to use for the Topic Operator.',
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
                        description: 'Logging configuration.',
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
                      reconciliationIntervalSeconds: {
                        description: 'Interval between periodic reconciliations.',
                        minimum: 0,
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
                      topicMetadataMaxAttempts: {
                        description: 'The number of attempts at getting topic metadata.',
                        minimum: 0,
                        type: 'integer',
                      },
                      watchedNamespace: {
                        description: 'The namespace the Topic Operator should watch.',
                        type: 'string',
                      },
                      zookeeperSessionTimeoutSeconds: {
                        description: 'Timeout for the ZooKeeper session.',
                        minimum: 0,
                        type: 'integer',
                      },
                    },
                    type: 'object',
                  },
                  userOperator: {
                    description: 'Configuration of the User Operator.',
                    properties: {
                      image: {
                        description: 'The image to use for the User Operator.',
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
                        description: 'Logging configuration.',
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
                      reconciliationIntervalSeconds: {
                        description: 'Interval between periodic reconciliations.',
                        minimum: 0,
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
                      watchedNamespace: {
                        description: 'The namespace the User Operator should watch.',
                        type: 'string',
                      },
                      zookeeperSessionTimeoutSeconds: {
                        description: 'Timeout for the ZooKeeper session.',
                        minimum: 0,
                        type: 'integer',
                      },
                    },
                    type: 'object',
                  },
                },
                type: 'object',
              },
              jmxTrans: {
                description: 'Configuration for JmxTrans. When the property is present a JmxTrans deployment is created for gathering JMX metrics from each Kafka broker. For more information see https://github.com/jmxtrans/jmxtrans[JmxTrans GitHub].',
                properties: {
                  image: {
                    description: 'The image to use for the JmxTrans.',
                    type: 'string',
                  },
                  kafkaQueries: {
                    description: 'Queries to send to the Kafka brokers to define what data should be read from each broker. For more information on these properties see, xref:type-JmxTransQueryTemplate-reference[`JmxTransQueryTemplate` schema reference].',
                    items: {
                      properties: {
                        attributes: {
                          description: 'Determine which attributes of the targeted MBean should be included.',
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        outputs: {
                          description: 'List of the names of output definitions specified in the spec.kafka.jmxTrans.outputDefinitions that have defined where JMX metrics are pushed to, and in which data format.',
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                        targetMBean: {
                          description: 'If using wildcards instead of a specific MBean then the data is gathered from multiple MBeans. Otherwise if specifying an MBean then data is gathered from that specified MBean.',
                          type: 'string',
                        },
                      },
                      required: [
                        'targetMBean',
                        'attributes',
                        'outputs',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  logLevel: {
                    description: 'Sets the logging level of the JmxTrans deployment.For more information see, https://github.com/jmxtrans/jmxtrans-agent/wiki/Troubleshooting[JmxTrans Logging Level].',
                    type: 'string',
                  },
                  outputDefinitions: {
                    description: 'Defines the output hosts that will be referenced later on. For more information on these properties see, xref:type-JmxTransOutputDefinitionTemplate-reference[`JmxTransOutputDefinitionTemplate` schema reference].',
                    items: {
                      properties: {
                        flushDelayInSeconds: {
                          description: 'How many seconds the JmxTrans waits before pushing a new set of data out.',
                          type: 'integer',
                        },
                        host: {
                          description: 'The DNS/hostname of the remote host that the data is pushed to.',
                          type: 'string',
                        },
                        name: {
                          description: 'Template for setting the name of the output definition. This is used to identify where to send the results of queries should be sent.',
                          type: 'string',
                        },
                        outputType: {
                          description: 'Template for setting the format of the data that will be pushed.For more information see https://github.com/jmxtrans/jmxtrans/wiki/OutputWriters[JmxTrans OutputWriters].',
                          type: 'string',
                        },
                        port: {
                          description: 'The port of the remote host that the data is pushed to.',
                          type: 'integer',
                        },
                        typeNames: {
                          description: 'Template for filtering data to be included in response to a wildcard query. For more information see https://github.com/jmxtrans/jmxtrans/wiki/Queries[JmxTrans queries].',
                          items: {
                            type: 'string',
                          },
                          type: 'array',
                        },
                      },
                      required: [
                        'outputType',
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
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
                    description: 'Template for JmxTrans resources.',
                    properties: {
                      container: {
                        description: 'Template for JmxTrans container.',
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
                      deployment: {
                        description: 'Template for JmxTrans `Deployment`.',
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
                      pod: {
                        description: 'Template for JmxTrans `Pods`.',
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
                    },
                    type: 'object',
                  },
                },
                required: [
                  'outputDefinitions',
                  'kafkaQueries',
                ],
                type: 'object',
              },
              kafka: {
                description: 'Configuration of the Kafka cluster.',
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
                  authorization: {
                    description: 'Authorization configuration for Kafka brokers.',
                    properties: {
                      clientId: {
                        description: 'OAuth Client ID which the Kafka client can use to authenticate against the OAuth server and use the token endpoint URI.',
                        type: 'string',
                      },
                      delegateToKafkaAcls: {
                        description: "Whether authorization decision should be delegated to the 'Simple' authorizer if DENIED by Keycloak Authorization Services policies.Default value is `false`.",
                        type: 'boolean',
                      },
                      disableTlsHostnameVerification: {
                        description: 'Enable or disable TLS hostname verification. Default value is `false`.',
                        type: 'boolean',
                      },
                      superUsers: {
                        description: 'List of super users. Should contain list of user principals which should get unlimited access rights.',
                        items: {
                          type: 'string',
                        },
                        type: 'array',
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
                        description: "Authorization type. Currently the only supported type is `simple`. `simple` authorization type uses Kafka's `kafka.security.auth.SimpleAclAuthorizer` class for authorization.",
                        enum: [
                          'simple',
                          'keycloak',
                        ],
                        type: 'string',
                      },
                    },
                    required: [
                      'type',
                    ],
                    type: 'object',
                  },
                  brokerRackInitImage: {
                    description: 'The image of the init container used for initializing the `broker.rack`.',
                    type: 'string',
                  },
                  config: {
                    description: 'The kafka broker config. Properties with the following prefixes cannot be set: listeners, advertised., broker., listener., host.name, port, inter.broker.listener.name, sasl., ssl., security., password., principal.builder.class, log.dir, zookeeper.connect, zookeeper.set.acl, authorizer., super.user, cruise.control.metrics.topic, cruise.control.metrics.reporter.bootstrap.servers (with the exception of: zookeeper.connection.timeout.ms, ssl.cipher.suites, ssl.protocol, ssl.enabled.protocols,cruise.control.metrics.topic.num.partitions, cruise.control.metrics.topic.replication.factor, cruise.control.metrics.topic.retention.ms).',
                    type: 'object',
                  },
                  image: {
                    description: 'The docker image for the pods. The default value depends on the configured `Kafka.spec.kafka.version`.',
                    type: 'string',
                  },
                  jmxOptions: {
                    description: 'JMX Options for Kafka brokers.',
                    properties: {
                      authentication: {
                        description: 'Authentication configuration for connecting to the Kafka JMX port.',
                        properties: {
                          type: {
                            description: 'Authentication type. Currently the only supported types are `password`.`password` type creates a username and protected port with no TLS.',
                            enum: [
                              'password',
                            ],
                            type: 'string',
                          },
                        },
                        required: [
                          'type',
                        ],
                        type: 'object',
                      },
                    },
                    type: 'object',
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
                  listeners: {
                    description: 'Configures listeners of Kafka brokers.',
                    properties: {
                      external: {
                        description: 'Configures external listener on port 9094.',
                        properties: {
                          authentication: {
                            description: 'Authentication configuration for Kafka brokers.',
                            properties: {
                              accessTokenIsJwt: {
                                description: 'Configure whether the access token is treated as JWT. This must be set to `false` if the authorization server returns opaque tokens. Defaults to `true`.',
                                type: 'boolean',
                              },
                              checkAccessTokenType: {
                                description: "Configure whether the access token type check is performed or not. This should be set to `false` if the authorization server does not include 'typ' claim in JWT token. Defaults to `true`.",
                                type: 'boolean',
                              },
                              checkIssuer: {
                                description: 'Enable or disable issuer checking. By default issuer is checked using the value configured by `validIssuerUri`. Default value is `true`.',
                                type: 'boolean',
                              },
                              clientId: {
                                description: 'OAuth Client ID which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
                                type: 'string',
                              },
                              clientSecret: {
                                description: 'Link to Kubernetes Secret containing the OAuth client secret which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
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
                              enableECDSA: {
                                description: 'Enable or disable ECDSA support by installing BouncyCastle crypto provider. Default value is `false`.',
                                type: 'boolean',
                              },
                              fallbackUserNameClaim: {
                                description: 'The fallback username claim to be used for the user id if the claim specified by `userNameClaim` is not present. This is useful when `client_credentials` authentication only results in the client id being provided in another claim. It only takes effect if `userNameClaim` is set.',
                                type: 'string',
                              },
                              fallbackUserNamePrefix: {
                                description: 'The prefix to use with the value of `fallbackUserNameClaim` to construct the user id. This only takes effect if `fallbackUserNameClaim` is true, and the value is present for the claim. Mapping usernames and client ids into the same user id space is useful in preventing name collisions.',
                                type: 'string',
                              },
                              introspectionEndpointUri: {
                                description: 'URI of the token introspection endpoint which can be used to validate opaque non-JWT tokens.',
                                type: 'string',
                              },
                              jwksEndpointUri: {
                                description: 'URI of the JWKS certificate endpoint, which can be used for local JWT validation.',
                                type: 'string',
                              },
                              jwksExpirySeconds: {
                                description: 'Configures how often are the JWKS certificates considered valid. The expiry interval has to be at least 60 seconds longer then the refresh interval specified in `jwksRefreshSeconds`. Defaults to 360 seconds.',
                                minimum: 1,
                                type: 'integer',
                              },
                              jwksRefreshSeconds: {
                                description: 'Configures how often are the JWKS certificates refreshed. The refresh interval has to be at least 60 seconds shorter then the expiry interval specified in `jwksExpirySeconds`. Defaults to 300 seconds.',
                                minimum: 1,
                                type: 'integer',
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
                              type: {
                                description: 'Authentication type. `oauth` type uses SASL OAUTHBEARER Authentication. `scram-sha-512` type uses SASL SCRAM-SHA-512 Authentication. `tls` type uses TLS Client Authentication. `tls` type is supported only on TLS listeners.',
                                enum: [
                                  'tls',
                                  'scram-sha-512',
                                  'oauth',
                                ],
                                type: 'string',
                              },
                              userInfoEndpointUri: {
                                description: 'URI of the User Info Endpoint to use as a fallback to obtaining the user id when the Introspection Endpoint does not return information that can be used for the user id. ',
                                type: 'string',
                              },
                              userNameClaim: {
                                description: 'Name of the claim from the JWT authentication token, Introspection Endpoint response or User Info Endpoint response which will be used to extract the user id. Defaults to `sub`.',
                                type: 'string',
                              },
                              validIssuerUri: {
                                description: 'URI of the token issuer used for authentication.',
                                type: 'string',
                              },
                              validTokenType: {
                                description: 'Valid value for the `token_type` attribute returned by the Introspection Endpoint. No default value, and not checked by default.',
                                type: 'string',
                              },
                            },
                            required: [
                              'type',
                            ],
                            type: 'object',
                          },
                          class: {
                            description: 'Configures the `Ingress` class that defines which `Ingress` controller will be used. If not set, the `Ingress` class is set to `nginx`.',
                            type: 'string',
                          },
                          configuration: {
                            description: 'External listener configuration.',
                            properties: {
                              bootstrap: {
                                description: 'External bootstrap ingress configuration.',
                                properties: {
                                  address: {
                                    description: 'Additional address name for the bootstrap service. The address will be added to the list of subject alternative names of the TLS certificates.',
                                    type: 'string',
                                  },
                                  dnsAnnotations: {
                                    description: 'Annotations that will be added to the `Ingress` resource. You can use this field to configure DNS providers such as External DNS.',
                                    type: 'object',
                                  },
                                  host: {
                                    description: 'Host for the bootstrap route. This field will be used in the Ingress resource.',
                                    type: 'string',
                                  },
                                },
                                required: [
                                  'host',
                                ],
                                type: 'object',
                              },
                              brokerCertChainAndKey: {
                                description: 'Reference to the `Secret` which holds the certificate and private key pair. The certificate can optionally contain the whole chain.',
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
                              brokers: {
                                description: 'External broker ingress configuration.',
                                items: {
                                  properties: {
                                    advertisedHost: {
                                      description: "The host name which will be used in the brokers' `advertised.brokers`.",
                                      type: 'string',
                                    },
                                    advertisedPort: {
                                      description: "The port number which will be used in the brokers' `advertised.brokers`.",
                                      type: 'integer',
                                    },
                                    broker: {
                                      description: 'Id of the kafka broker (broker identifier).',
                                      type: 'integer',
                                    },
                                    dnsAnnotations: {
                                      description: 'Annotations that will be added to the `Ingress` resources for individual brokers. You can use this field to configure DNS providers such as External DNS.',
                                      type: 'object',
                                    },
                                    host: {
                                      description: 'Host for the broker ingress. This field will be used in the Ingress resource.',
                                      type: 'string',
                                    },
                                  },
                                  required: [
                                    'host',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          networkPolicyPeers: {
                            description: 'List of peers which should be able to connect to this listener. Peers in this list are combined using a logical OR operation. If this field is empty or missing, all connections will be allowed for this listener. If this field is present and contains at least one item, the listener only allows the traffic which matches at least one item in this list.',
                            items: {
                              properties: {
                                ipBlock: {
                                  properties: {
                                    cidr: {
                                      type: 'string',
                                    },
                                    except: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaceSelector: {
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
                                podSelector: {
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
                              },
                              type: 'object',
                            },
                            type: 'array',
                          },
                          overrides: {
                            description: 'Overrides for external bootstrap and broker services and externally advertised addresses.',
                            properties: {
                              bootstrap: {
                                description: 'External bootstrap service configuration.',
                                properties: {
                                  address: {
                                    description: 'Additional address name for the bootstrap service. The address will be added to the list of subject alternative names of the TLS certificates.',
                                    type: 'string',
                                  },
                                  dnsAnnotations: {
                                    description: 'Annotations that will be added to the `Service` resource. You can use this field to configure DNS providers such as External DNS.',
                                    type: 'object',
                                  },
                                  nodePort: {
                                    description: 'Node port for the bootstrap service.',
                                    type: 'integer',
                                  },
                                },
                                type: 'object',
                              },
                              brokers: {
                                description: 'External broker services configuration.',
                                items: {
                                  properties: {
                                    advertisedHost: {
                                      description: "The host name which will be used in the brokers' `advertised.brokers`.",
                                      type: 'string',
                                    },
                                    advertisedPort: {
                                      description: "The port number which will be used in the brokers' `advertised.brokers`.",
                                      type: 'integer',
                                    },
                                    broker: {
                                      description: 'Id of the kafka broker (broker identifier).',
                                      type: 'integer',
                                    },
                                    dnsAnnotations: {
                                      description: 'Annotations that will be added to the `Service` resources for individual brokers. You can use this field to configure DNS providers such as External DNS.',
                                      type: 'object',
                                    },
                                    nodePort: {
                                      description: 'Node port for the broker service.',
                                      type: 'integer',
                                    },
                                  },
                                  type: 'object',
                                },
                                type: 'array',
                              },
                            },
                            type: 'object',
                          },
                          tls: {
                            description: 'Enables TLS encryption on the listener. By default set to `true` for enabled TLS encryption.',
                            type: 'boolean',
                          },
                          type: {
                            description: 'Type of the external listener. Currently the supported types are `route`, `loadbalancer`, and `nodeport`. \n\n* `route` type uses OpenShift Routes to expose Kafka.* `loadbalancer` type uses LoadBalancer type services to expose Kafka.* `nodeport` type uses NodePort type services to expose Kafka..',
                            enum: [
                              'route',
                              'loadbalancer',
                              'nodeport',
                              'ingress',
                            ],
                            type: 'string',
                          },
                        },
                        required: [
                          'type',
                        ],
                        type: 'object',
                      },
                      plain: {
                        description: 'Configures plain listener on port 9092.',
                        properties: {
                          authentication: {
                            description: 'Authentication configuration for this listener. Since this listener does not use TLS transport you cannot configure an authentication with `type: tls`.',
                            properties: {
                              accessTokenIsJwt: {
                                description: 'Configure whether the access token is treated as JWT. This must be set to `false` if the authorization server returns opaque tokens. Defaults to `true`.',
                                type: 'boolean',
                              },
                              checkAccessTokenType: {
                                description: "Configure whether the access token type check is performed or not. This should be set to `false` if the authorization server does not include 'typ' claim in JWT token. Defaults to `true`.",
                                type: 'boolean',
                              },
                              checkIssuer: {
                                description: 'Enable or disable issuer checking. By default issuer is checked using the value configured by `validIssuerUri`. Default value is `true`.',
                                type: 'boolean',
                              },
                              clientId: {
                                description: 'OAuth Client ID which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
                                type: 'string',
                              },
                              clientSecret: {
                                description: 'Link to Kubernetes Secret containing the OAuth client secret which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
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
                              enableECDSA: {
                                description: 'Enable or disable ECDSA support by installing BouncyCastle crypto provider. Default value is `false`.',
                                type: 'boolean',
                              },
                              fallbackUserNameClaim: {
                                description: 'The fallback username claim to be used for the user id if the claim specified by `userNameClaim` is not present. This is useful when `client_credentials` authentication only results in the client id being provided in another claim. It only takes effect if `userNameClaim` is set.',
                                type: 'string',
                              },
                              fallbackUserNamePrefix: {
                                description: 'The prefix to use with the value of `fallbackUserNameClaim` to construct the user id. This only takes effect if `fallbackUserNameClaim` is true, and the value is present for the claim. Mapping usernames and client ids into the same user id space is useful in preventing name collisions.',
                                type: 'string',
                              },
                              introspectionEndpointUri: {
                                description: 'URI of the token introspection endpoint which can be used to validate opaque non-JWT tokens.',
                                type: 'string',
                              },
                              jwksEndpointUri: {
                                description: 'URI of the JWKS certificate endpoint, which can be used for local JWT validation.',
                                type: 'string',
                              },
                              jwksExpirySeconds: {
                                description: 'Configures how often are the JWKS certificates considered valid. The expiry interval has to be at least 60 seconds longer then the refresh interval specified in `jwksRefreshSeconds`. Defaults to 360 seconds.',
                                minimum: 1,
                                type: 'integer',
                              },
                              jwksRefreshSeconds: {
                                description: 'Configures how often are the JWKS certificates refreshed. The refresh interval has to be at least 60 seconds shorter then the expiry interval specified in `jwksExpirySeconds`. Defaults to 300 seconds.',
                                minimum: 1,
                                type: 'integer',
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
                              type: {
                                description: 'Authentication type. `oauth` type uses SASL OAUTHBEARER Authentication. `scram-sha-512` type uses SASL SCRAM-SHA-512 Authentication. `tls` type uses TLS Client Authentication. `tls` type is supported only on TLS listeners.',
                                enum: [
                                  'tls',
                                  'scram-sha-512',
                                  'oauth',
                                ],
                                type: 'string',
                              },
                              userInfoEndpointUri: {
                                description: 'URI of the User Info Endpoint to use as a fallback to obtaining the user id when the Introspection Endpoint does not return information that can be used for the user id. ',
                                type: 'string',
                              },
                              userNameClaim: {
                                description: 'Name of the claim from the JWT authentication token, Introspection Endpoint response or User Info Endpoint response which will be used to extract the user id. Defaults to `sub`.',
                                type: 'string',
                              },
                              validIssuerUri: {
                                description: 'URI of the token issuer used for authentication.',
                                type: 'string',
                              },
                              validTokenType: {
                                description: 'Valid value for the `token_type` attribute returned by the Introspection Endpoint. No default value, and not checked by default.',
                                type: 'string',
                              },
                            },
                            required: [
                              'type',
                            ],
                            type: 'object',
                          },
                          networkPolicyPeers: {
                            description: 'List of peers which should be able to connect to this listener. Peers in this list are combined using a logical OR operation. If this field is empty or missing, all connections will be allowed for this listener. If this field is present and contains at least one item, the listener only allows the traffic which matches at least one item in this list.',
                            items: {
                              properties: {
                                ipBlock: {
                                  properties: {
                                    cidr: {
                                      type: 'string',
                                    },
                                    except: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaceSelector: {
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
                                podSelector: {
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
                              },
                              type: 'object',
                            },
                            type: 'array',
                          },
                        },
                        type: 'object',
                      },
                      tls: {
                        description: 'Configures TLS listener on port 9093.',
                        properties: {
                          authentication: {
                            description: 'Authentication configuration for this listener.',
                            properties: {
                              accessTokenIsJwt: {
                                description: 'Configure whether the access token is treated as JWT. This must be set to `false` if the authorization server returns opaque tokens. Defaults to `true`.',
                                type: 'boolean',
                              },
                              checkAccessTokenType: {
                                description: "Configure whether the access token type check is performed or not. This should be set to `false` if the authorization server does not include 'typ' claim in JWT token. Defaults to `true`.",
                                type: 'boolean',
                              },
                              checkIssuer: {
                                description: 'Enable or disable issuer checking. By default issuer is checked using the value configured by `validIssuerUri`. Default value is `true`.',
                                type: 'boolean',
                              },
                              clientId: {
                                description: 'OAuth Client ID which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
                                type: 'string',
                              },
                              clientSecret: {
                                description: 'Link to Kubernetes Secret containing the OAuth client secret which the Kafka broker can use to authenticate against the authorization server and use the introspect endpoint URI.',
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
                              enableECDSA: {
                                description: 'Enable or disable ECDSA support by installing BouncyCastle crypto provider. Default value is `false`.',
                                type: 'boolean',
                              },
                              fallbackUserNameClaim: {
                                description: 'The fallback username claim to be used for the user id if the claim specified by `userNameClaim` is not present. This is useful when `client_credentials` authentication only results in the client id being provided in another claim. It only takes effect if `userNameClaim` is set.',
                                type: 'string',
                              },
                              fallbackUserNamePrefix: {
                                description: 'The prefix to use with the value of `fallbackUserNameClaim` to construct the user id. This only takes effect if `fallbackUserNameClaim` is true, and the value is present for the claim. Mapping usernames and client ids into the same user id space is useful in preventing name collisions.',
                                type: 'string',
                              },
                              introspectionEndpointUri: {
                                description: 'URI of the token introspection endpoint which can be used to validate opaque non-JWT tokens.',
                                type: 'string',
                              },
                              jwksEndpointUri: {
                                description: 'URI of the JWKS certificate endpoint, which can be used for local JWT validation.',
                                type: 'string',
                              },
                              jwksExpirySeconds: {
                                description: 'Configures how often are the JWKS certificates considered valid. The expiry interval has to be at least 60 seconds longer then the refresh interval specified in `jwksRefreshSeconds`. Defaults to 360 seconds.',
                                minimum: 1,
                                type: 'integer',
                              },
                              jwksRefreshSeconds: {
                                description: 'Configures how often are the JWKS certificates refreshed. The refresh interval has to be at least 60 seconds shorter then the expiry interval specified in `jwksExpirySeconds`. Defaults to 300 seconds.',
                                minimum: 1,
                                type: 'integer',
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
                              type: {
                                description: 'Authentication type. `oauth` type uses SASL OAUTHBEARER Authentication. `scram-sha-512` type uses SASL SCRAM-SHA-512 Authentication. `tls` type uses TLS Client Authentication. `tls` type is supported only on TLS listeners.',
                                enum: [
                                  'tls',
                                  'scram-sha-512',
                                  'oauth',
                                ],
                                type: 'string',
                              },
                              userInfoEndpointUri: {
                                description: 'URI of the User Info Endpoint to use as a fallback to obtaining the user id when the Introspection Endpoint does not return information that can be used for the user id. ',
                                type: 'string',
                              },
                              userNameClaim: {
                                description: 'Name of the claim from the JWT authentication token, Introspection Endpoint response or User Info Endpoint response which will be used to extract the user id. Defaults to `sub`.',
                                type: 'string',
                              },
                              validIssuerUri: {
                                description: 'URI of the token issuer used for authentication.',
                                type: 'string',
                              },
                              validTokenType: {
                                description: 'Valid value for the `token_type` attribute returned by the Introspection Endpoint. No default value, and not checked by default.',
                                type: 'string',
                              },
                            },
                            required: [
                              'type',
                            ],
                            type: 'object',
                          },
                          configuration: {
                            description: 'Configuration of TLS listener.',
                            properties: {
                              brokerCertChainAndKey: {
                                description: 'Reference to the `Secret` which holds the certificate and private key pair. The certificate can optionally contain the whole chain.',
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
                            },
                            type: 'object',
                          },
                          networkPolicyPeers: {
                            description: 'List of peers which should be able to connect to this listener. Peers in this list are combined using a logical OR operation. If this field is empty or missing, all connections will be allowed for this listener. If this field is present and contains at least one item, the listener only allows the traffic which matches at least one item in this list.',
                            items: {
                              properties: {
                                ipBlock: {
                                  properties: {
                                    cidr: {
                                      type: 'string',
                                    },
                                    except: {
                                      items: {
                                        type: 'string',
                                      },
                                      type: 'array',
                                    },
                                  },
                                  type: 'object',
                                },
                                namespaceSelector: {
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
                                podSelector: {
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
                    description: 'Logging configuration for Kafka.',
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
                    description: 'The Prometheus JMX Exporter configuration. See https://github.com/prometheus/jmx_exporter for details of the structure of this configuration.',
                    type: 'object',
                  },
                  rack: {
                    description: 'Configuration of the `broker.rack` broker config.',
                    properties: {
                      topologyKey: {
                        description: "A key that matches labels assigned to the Kubernetes cluster nodes. The value of the label is used to set the broker's `broker.rack` config.",
                        example: 'failure-domain.beta.kubernetes.io/zone',
                        type: 'string',
                      },
                    },
                    required: [
                      'topologyKey',
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
                    description: 'The number of pods in the cluster.',
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
                  storage: {
                    description: 'Storage configuration (disk). Cannot be updated.',
                    properties: {
                      class: {
                        description: 'The storage class to use for dynamic volume allocation.',
                        type: 'string',
                      },
                      deleteClaim: {
                        description: 'Specifies if the persistent volume claim has to be deleted when the cluster is un-deployed.',
                        type: 'boolean',
                      },
                      id: {
                        description: "Storage identification number. It is mandatory only for storage volumes defined in a storage of type 'jbod'.",
                        minimum: 0,
                        type: 'integer',
                      },
                      overrides: {
                        description: 'Overrides for individual brokers. The `overrides` field allows to specify a different configuration for different brokers.',
                        items: {
                          properties: {
                            broker: {
                              description: 'Id of the kafka broker (broker identifier).',
                              type: 'integer',
                            },
                            class: {
                              description: 'The storage class to use for dynamic volume allocation for this broker.',
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      selector: {
                        description: 'Specifies a specific persistent volume to use. It contains key:value pairs representing labels for selecting such a volume.',
                        type: 'object',
                      },
                      size: {
                        description: 'When type=persistent-claim, defines the size of the persistent volume claim (i.e 1Gi). Mandatory when type=persistent-claim.',
                        type: 'string',
                      },
                      sizeLimit: {
                        description: 'When type=ephemeral, defines the total amount of local storage required for this EmptyDir volume (for example 1Gi).',
                        pattern: '^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$',
                        type: 'string',
                      },
                      type: {
                        description: "Storage type, must be either 'ephemeral', 'persistent-claim', or 'jbod'.",
                        enum: [
                          'ephemeral',
                          'persistent-claim',
                          'jbod',
                        ],
                        type: 'string',
                      },
                      volumes: {
                        description: 'List of volumes as Storage objects representing the JBOD disks array.',
                        items: {
                          properties: {
                            class: {
                              description: 'The storage class to use for dynamic volume allocation.',
                              type: 'string',
                            },
                            deleteClaim: {
                              description: 'Specifies if the persistent volume claim has to be deleted when the cluster is un-deployed.',
                              type: 'boolean',
                            },
                            id: {
                              description: "Storage identification number. It is mandatory only for storage volumes defined in a storage of type 'jbod'.",
                              minimum: 0,
                              type: 'integer',
                            },
                            overrides: {
                              description: 'Overrides for individual brokers. The `overrides` field allows to specify a different configuration for different brokers.',
                              items: {
                                properties: {
                                  broker: {
                                    description: 'Id of the kafka broker (broker identifier).',
                                    type: 'integer',
                                  },
                                  class: {
                                    description: 'The storage class to use for dynamic volume allocation for this broker.',
                                    type: 'string',
                                  },
                                },
                                type: 'object',
                              },
                              type: 'array',
                            },
                            selector: {
                              description: 'Specifies a specific persistent volume to use. It contains key:value pairs representing labels for selecting such a volume.',
                              type: 'object',
                            },
                            size: {
                              description: 'When type=persistent-claim, defines the size of the persistent volume claim (i.e 1Gi). Mandatory when type=persistent-claim.',
                              type: 'string',
                            },
                            sizeLimit: {
                              description: 'When type=ephemeral, defines the total amount of local storage required for this EmptyDir volume (for example 1Gi).',
                              pattern: '^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$',
                              type: 'string',
                            },
                            type: {
                              description: "Storage type, must be either 'ephemeral' or 'persistent-claim'.",
                              enum: [
                                'ephemeral',
                                'persistent-claim',
                              ],
                              type: 'string',
                            },
                          },
                          required: [
                            'type',
                          ],
                          type: 'object',
                        },
                        type: 'array',
                      },
                    },
                    required: [
                      'type',
                    ],
                    type: 'object',
                  },
                  template: {
                    description: 'Template for Kafka cluster resources. The template allows users to specify how are the `StatefulSet`, `Pods` and `Services` generated.',
                    properties: {
                      bootstrapService: {
                        description: 'Template for Kafka bootstrap `Service`.',
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
                      brokersService: {
                        description: 'Template for Kafka broker `Service`.',
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
                      externalBootstrapIngress: {
                        description: 'Template for Kafka external bootstrap `Ingress`.',
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
                      externalBootstrapRoute: {
                        description: 'Template for Kafka external bootstrap `Route`.',
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
                      externalBootstrapService: {
                        description: 'Template for Kafka external bootstrap `Service`.',
                        properties: {
                          externalTrafficPolicy: {
                            description: 'Specifies whether the service routes external traffic to node-local or cluster-wide endpoints. `Cluster` may cause a second hop to another node and obscures the client source IP. `Local` avoids a second hop for LoadBalancer and Nodeport type services and preserves the client source IP (when supported by the infrastructure). If unspecified, Kubernetes will use `Cluster` as the default.',
                            enum: [
                              'Local',
                              'Cluster',
                            ],
                            type: 'string',
                          },
                          loadBalancerSourceRanges: {
                            description: 'A list of CIDR ranges (for example `10.0.0.0/8` or `130.211.204.1/32`) from which clients can connect to load balancer type listeners. If supported by the platform, traffic through the loadbalancer is restricted to the specified CIDR ranges. This field is applicable only for loadbalancer type services and is ignored if the cloud provider does not support the feature. For more information, see https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/.',
                            items: {
                              type: 'string',
                            },
                            type: 'array',
                          },
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
                      initContainer: {
                        description: 'Template for the Kafka init container.',
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
                      kafkaContainer: {
                        description: 'Template for the Kafka broker container.',
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
                      perPodIngress: {
                        description: 'Template for Kafka per-pod `Ingress` used for access from outside of Kubernetes.',
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
                      perPodRoute: {
                        description: 'Template for Kafka per-pod `Routes` used for access from outside of OpenShift.',
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
                      perPodService: {
                        description: 'Template for Kafka per-pod `Services` used for access from outside of Kubernetes.',
                        properties: {
                          externalTrafficPolicy: {
                            description: 'Specifies whether the service routes external traffic to node-local or cluster-wide endpoints. `Cluster` may cause a second hop to another node and obscures the client source IP. `Local` avoids a second hop for LoadBalancer and Nodeport type services and preserves the client source IP (when supported by the infrastructure). If unspecified, Kubernetes will use `Cluster` as the default.',
                            enum: [
                              'Local',
                              'Cluster',
                            ],
                            type: 'string',
                          },
                          loadBalancerSourceRanges: {
                            description: 'A list of CIDR ranges (for example `10.0.0.0/8` or `130.211.204.1/32`) from which clients can connect to load balancer type listeners. If supported by the platform, traffic through the loadbalancer is restricted to the specified CIDR ranges. This field is applicable only for loadbalancer type services and is ignored if the cloud provider does not support the feature. For more information, see https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/.',
                            items: {
                              type: 'string',
                            },
                            type: 'array',
                          },
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
                      persistentVolumeClaim: {
                        description: 'Template for all Kafka `PersistentVolumeClaims`.',
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
                      pod: {
                        description: 'Template for Kafka `Pods`.',
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
                        description: 'Template for Kafka `PodDisruptionBudget`.',
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
                      statefulset: {
                        description: 'Template for Kafka `StatefulSet`.',
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
                          podManagementPolicy: {
                            description: 'PodManagementPolicy which will be used for this StatefulSet. Valid values are `Parallel` and `OrderedReady`. Defaults to `Parallel`.',
                            enum: [
                              'OrderedReady',
                              'Parallel',
                            ],
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      tlsSidecarContainer: {
                        description: 'Template for the Kafka broker TLS sidecar container.',
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
                    },
                    type: 'object',
                  },
                  tlsSidecar: {
                    description: 'TLS sidecar configuration.',
                    properties: {
                      image: {
                        description: 'The docker image for the container.',
                        type: 'string',
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
                      logLevel: {
                        description: 'The log level for the TLS sidecar. Default value is `notice`.',
                        enum: [
                          'emerg',
                          'alert',
                          'crit',
                          'err',
                          'warning',
                          'notice',
                          'info',
                          'debug',
                        ],
                        type: 'string',
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
                  version: {
                    description: 'The kafka broker version. Defaults to {DefaultKafkaVersion}. Consult the user documentation to understand the process required to upgrade or downgrade the version.',
                    type: 'string',
                  },
                },
                required: [
                  'replicas',
                  'storage',
                  'listeners',
                ],
                type: 'object',
              },
              kafkaExporter: {
                description: 'Configuration of the Kafka Exporter. Kafka Exporter can provide additional metrics, for example lag of consumer group at topic/partition.',
                properties: {
                  enableSaramaLogging: {
                    description: 'Enable Sarama logging, a Go client library used by the Kafka Exporter.',
                    type: 'boolean',
                  },
                  groupRegex: {
                    description: 'Regular expression to specify which consumer groups to collect. Default value is `.*`.',
                    type: 'string',
                  },
                  image: {
                    description: 'The docker image for the pods.',
                    type: 'string',
                  },
                  livenessProbe: {
                    description: 'Pod liveness check.',
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
                    description: 'Only log messages with the given severity or above. Valid levels: [`debug`, `info`, `warn`, `error`, `fatal`]. Default log level is `info`.',
                    type: 'string',
                  },
                  readinessProbe: {
                    description: 'Pod readiness check.',
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
                    description: 'Customization of deployment templates and pods.',
                    properties: {
                      container: {
                        description: 'Template for the Kafka Exporter container.',
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
                      deployment: {
                        description: 'Template for Kafka Exporter `Deployment`.',
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
                      pod: {
                        description: 'Template for Kafka Exporter `Pods`.',
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
                      service: {
                        description: 'Template for Kafka Exporter `Service`.',
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
                    },
                    type: 'object',
                  },
                  topicRegex: {
                    description: 'Regular expression to specify which topics to collect. Default value is `.*`.',
                    type: 'string',
                  },
                },
                type: 'object',
              },
              maintenanceTimeWindows: {
                description: 'A list of time windows for maintenance tasks (that is, certificates renewal). Each time window is defined by a cron expression.',
                items: {
                  type: 'string',
                },
                type: 'array',
              },
              topicOperator: {
                description: 'Configuration of the Topic Operator.',
                properties: {
                  affinity: {
                    description: 'Pod affinity rules.',
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
                  image: {
                    description: 'The image to use for the Topic Operator.',
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
                    description: 'Logging configuration.',
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
                  reconciliationIntervalSeconds: {
                    description: 'Interval between periodic reconciliations.',
                    minimum: 0,
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
                  tlsSidecar: {
                    description: 'TLS sidecar configuration.',
                    properties: {
                      image: {
                        description: 'The docker image for the container.',
                        type: 'string',
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
                      logLevel: {
                        description: 'The log level for the TLS sidecar. Default value is `notice`.',
                        enum: [
                          'emerg',
                          'alert',
                          'crit',
                          'err',
                          'warning',
                          'notice',
                          'info',
                          'debug',
                        ],
                        type: 'string',
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
                    },
                    type: 'object',
                  },
                  topicMetadataMaxAttempts: {
                    description: 'The number of attempts at getting topic metadata.',
                    minimum: 0,
                    type: 'integer',
                  },
                  watchedNamespace: {
                    description: 'The namespace the Topic Operator should watch.',
                    type: 'string',
                  },
                  zookeeperSessionTimeoutSeconds: {
                    description: 'Timeout for the ZooKeeper session.',
                    minimum: 0,
                    type: 'integer',
                  },
                },
                type: 'object',
              },
              zookeeper: {
                description: 'Configuration of the ZooKeeper cluster.',
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
                  config: {
                    description: 'The ZooKeeper broker config. Properties with the following prefixes cannot be set: server., dataDir, dataLogDir, clientPort, authProvider, quorum.auth, requireClientAuthScheme, snapshot.trust.empty, standaloneEnabled, reconfigEnabled, 4lw.commands.whitelist, secureClientPort, ssl., serverCnxnFactory, sslQuorum (with the exception of: ssl.protocol, ssl.quorum.protocol, ssl.enabledProtocols, ssl.quorum.enabledProtocols, ssl.ciphersuites, ssl.quorum.ciphersuites).',
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
                    description: 'Logging configuration for ZooKeeper.',
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
                    description: 'The Prometheus JMX Exporter configuration. See https://github.com/prometheus/jmx_exporter for details of the structure of this configuration.',
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
                    description: 'The number of pods in the cluster.',
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
                  storage: {
                    description: 'Storage configuration (disk). Cannot be updated.',
                    properties: {
                      class: {
                        description: 'The storage class to use for dynamic volume allocation.',
                        type: 'string',
                      },
                      deleteClaim: {
                        description: 'Specifies if the persistent volume claim has to be deleted when the cluster is un-deployed.',
                        type: 'boolean',
                      },
                      id: {
                        description: "Storage identification number. It is mandatory only for storage volumes defined in a storage of type 'jbod'.",
                        minimum: 0,
                        type: 'integer',
                      },
                      overrides: {
                        description: 'Overrides for individual brokers. The `overrides` field allows to specify a different configuration for different brokers.',
                        items: {
                          properties: {
                            broker: {
                              description: 'Id of the kafka broker (broker identifier).',
                              type: 'integer',
                            },
                            class: {
                              description: 'The storage class to use for dynamic volume allocation for this broker.',
                              type: 'string',
                            },
                          },
                          type: 'object',
                        },
                        type: 'array',
                      },
                      selector: {
                        description: 'Specifies a specific persistent volume to use. It contains key:value pairs representing labels for selecting such a volume.',
                        type: 'object',
                      },
                      size: {
                        description: 'When type=persistent-claim, defines the size of the persistent volume claim (i.e 1Gi). Mandatory when type=persistent-claim.',
                        type: 'string',
                      },
                      sizeLimit: {
                        description: 'When type=ephemeral, defines the total amount of local storage required for this EmptyDir volume (for example 1Gi).',
                        pattern: '^([0-9.]+)([eEinumkKMGTP]*[-+]?[0-9]*)$',
                        type: 'string',
                      },
                      type: {
                        description: "Storage type, must be either 'ephemeral' or 'persistent-claim'.",
                        enum: [
                          'ephemeral',
                          'persistent-claim',
                        ],
                        type: 'string',
                      },
                    },
                    required: [
                      'type',
                    ],
                    type: 'object',
                  },
                  template: {
                    description: 'Template for ZooKeeper cluster resources. The template allows users to specify how are the `StatefulSet`, `Pods` and `Services` generated.',
                    properties: {
                      clientService: {
                        description: 'Template for ZooKeeper client `Service`.',
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
                      nodesService: {
                        description: 'Template for ZooKeeper nodes `Service`.',
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
                      persistentVolumeClaim: {
                        description: 'Template for all ZooKeeper `PersistentVolumeClaims`.',
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
                      pod: {
                        description: 'Template for ZooKeeper `Pods`.',
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
                        description: 'Template for ZooKeeper `PodDisruptionBudget`.',
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
                      statefulset: {
                        description: 'Template for ZooKeeper `StatefulSet`.',
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
                          podManagementPolicy: {
                            description: 'PodManagementPolicy which will be used for this StatefulSet. Valid values are `Parallel` and `OrderedReady`. Defaults to `Parallel`.',
                            enum: [
                              'OrderedReady',
                              'Parallel',
                            ],
                            type: 'string',
                          },
                        },
                        type: 'object',
                      },
                      tlsSidecarContainer: {
                        description: 'Template for the Zookeeper server TLS sidecar container. The TLS sidecar is not used anymore and this option will be ignored.',
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
                      zookeeperContainer: {
                        description: 'Template for the ZooKeeper container.',
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
                    },
                    type: 'object',
                  },
                  tlsSidecar: {
                    description: 'TLS sidecar configuration. The TLS sidecar is not used anymore and this option will be ignored.',
                    properties: {
                      image: {
                        description: 'The docker image for the container.',
                        type: 'string',
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
                      logLevel: {
                        description: 'The log level for the TLS sidecar. Default value is `notice`.',
                        enum: [
                          'emerg',
                          'alert',
                          'crit',
                          'err',
                          'warning',
                          'notice',
                          'info',
                          'debug',
                        ],
                        type: 'string',
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
                },
                required: [
                  'replicas',
                  'storage',
                ],
                type: 'object',
              },
            },
            required: [
              'kafka',
              'zookeeper',
            ],
            type: 'object',
          },
          status: {
            description: 'The status of the Kafka and ZooKeeper clusters, and Topic Operator.',
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
              listeners: {
                description: 'Addresses of the internal and external listeners.',
                items: {
                  properties: {
                    addresses: {
                      description: 'A list of the addresses for this listener.',
                      items: {
                        properties: {
                          host: {
                            description: 'The DNS name or IP address of the Kafka bootstrap service.',
                            type: 'string',
                          },
                          port: {
                            description: 'The port of the Kafka bootstrap service.',
                            type: 'integer',
                          },
                        },
                        type: 'object',
                      },
                      type: 'array',
                    },
                    bootstrapServers: {
                      description: 'A comma-separated list of `host:port` pairs for connecting to the Kafka cluster using this listener.',
                      type: 'string',
                    },
                    certificates: {
                      description: 'A list of TLS certificates which can be used to verify the identity of the server when connecting to the given listener. Set only for `tls` and `external` listeners.',
                      items: {
                        type: 'string',
                      },
                      type: 'array',
                    },
                    type: {
                      description: 'The type of the listener. Can be one of the following three types: `plain`, `tls`, and `external`.',
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
