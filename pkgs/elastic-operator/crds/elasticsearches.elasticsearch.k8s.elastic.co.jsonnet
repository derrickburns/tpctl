{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    creationTimestamp: null,
    name: 'elasticsearches.elasticsearch.k8s.elastic.co',
  },
  spec: {
    additionalPrinterColumns: [
      {
        JSONPath: '.status.health',
        name: 'health',
        type: 'string',
      },
      {
        JSONPath: '.status.availableNodes',
        description: 'Available nodes',
        name: 'nodes',
        type: 'integer',
      },
      {
        JSONPath: '.spec.version',
        description: 'Elasticsearch version',
        name: 'version',
        type: 'string',
      },
      {
        JSONPath: '.status.phase',
        name: 'phase',
        type: 'string',
      },
      {
        JSONPath: '.metadata.creationTimestamp',
        name: 'age',
        type: 'date',
      },
    ],
    group: 'elasticsearch.k8s.elastic.co',
    names: {
      categories: [
        'elastic',
      ],
      kind: 'Elasticsearch',
      listKind: 'ElasticsearchList',
      plural: 'elasticsearches',
      shortNames: [
        'es',
      ],
      singular: 'elasticsearch',
    },
    scope: 'Namespaced',
    subresources: {
      status: {},
    },
    version: 'v1alpha1',
    versions: [
      {
        name: 'v1alpha1',
        schema: {
          openAPIV3Schema: {
            description: 'Elasticsearch is the Schema for the elasticsearches API',
            properties: {
              apiVersion: {
                description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources',
                type: 'string',
              },
              kind: {
                description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds',
                type: 'string',
              },
              metadata: {
                type: 'object',
              },
              spec: {
                description: 'ElasticsearchSpec defines the desired state of Elasticsearch',
                properties: {
                  http: {
                    description: 'HTTP contains settings for HTTP.',
                    properties: {
                      service: {
                        description: 'Service is a template for the Kubernetes Service',
                        properties: {
                          metadata: {
                            description: 'ObjectMeta is metadata for the service. The name and namespace provided here is managed by ECK and will be ignored.',
                            type: 'object',
                          },
                          spec: {
                            description: 'Spec defines the behavior of the service.',
                            properties: {
                              clusterIP: {
                                description: 'clusterIP is the IP address of the service and is usually assigned randomly by the master. If an address is specified manually and is not in use by others, it will be allocated to the service; otherwise, creation of the service will fail. This field can not be changed through updates. Valid values are "None", empty string (""), or a valid IP address. "None" can be specified for headless services when proxying is not required. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                type: 'string',
                              },
                              externalIPs: {
                                description: 'externalIPs is a list of IP addresses for which nodes in the cluster will also accept traffic for this service.  These IPs are not managed by Kubernetes.  The user is responsible for ensuring that traffic arrives at a node with this IP.  A common example is external load-balancers that are not part of the Kubernetes system.',
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                              externalName: {
                                description: 'externalName is the external reference that kubedns or equivalent will return as a CNAME record for this service. No proxying will be involved. Must be a valid RFC-1123 hostname (https://tools.ietf.org/html/rfc1123) and requires Type to be ExternalName.',
                                type: 'string',
                              },
                              externalTrafficPolicy: {
                                description: 'externalTrafficPolicy denotes if this Service desires to route external traffic to node-local or cluster-wide endpoints. "Local" preserves the client source IP and avoids a second hop for LoadBalancer and Nodeport type services, but risks potentially imbalanced traffic spreading. "Cluster" obscures the client source IP and may cause a second hop to another node, but should have good overall load-spreading.',
                                type: 'string',
                              },
                              healthCheckNodePort: {
                                description: 'healthCheckNodePort specifies the healthcheck nodePort for the service. If not specified, HealthCheckNodePort is created by the service api backend with the allocated nodePort. Will use user-specified nodePort value if specified by the client. Only effects when Type is set to LoadBalancer and ExternalTrafficPolicy is set to Local.',
                                format: 'int32',
                                type: 'integer',
                              },
                              loadBalancerIP: {
                                description: 'Only applies to Service Type: LoadBalancer LoadBalancer will get created with the IP specified in this field. This feature depends on whether the underlying cloud-provider supports specifying the loadBalancerIP when a load balancer is created. This field will be ignored if the cloud-provider does not support the feature.',
                                type: 'string',
                              },
                              loadBalancerSourceRanges: {
                                description: 'If specified and supported by the platform, this will restrict traffic through the cloud-provider load-balancer will be restricted to the specified client IPs. This field will be ignored if the cloud-provider does not support the feature." More info: https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/',
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                              ports: {
                                description: 'The list of ports that are exposed by this service. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                items: {
                                  description: "ServicePort contains information on service's port.",
                                  properties: {
                                    name: {
                                      description: "The name of this port within the service. This must be a DNS_LABEL. All ports within a ServiceSpec must have unique names. This maps to the 'Name' field in EndpointPort objects. Optional if only one ServicePort is defined on this service.",
                                      type: 'string',
                                    },
                                    nodePort: {
                                      description: 'The port on each node on which this service is exposed when type=NodePort or LoadBalancer. Usually assigned by the system. If specified, it will be allocated to the service if unused or else creation of the service will fail. Default is to auto-allocate a port if the ServiceType of this Service requires one. More info: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport',
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                    port: {
                                      description: 'The port that will be exposed by this service.',
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                    protocol: {
                                      description: 'The IP protocol for this port. Supports "TCP", "UDP", and "SCTP". Default is TCP.',
                                      type: 'string',
                                    },
                                    targetPort: {
                                      anyOf: [
                                        {
                                          type: 'string',
                                        },
                                        {
                                          type: 'integer',
                                        },
                                      ],
                                      description: "Number or name of the port to access on the pods targeted by the service. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME. If this is a string, it will be looked up as a named port in the target Pod's container ports. If this is not specified, the value of the 'port' field is used (an identity map). This field is ignored for services with clusterIP=None, and should be omitted or set equal to the 'port' field. More info: https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service",
                                    },
                                  },
                                  required: [
                                    'port',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              publishNotReadyAddresses: {
                                description: "publishNotReadyAddresses, when set to true, indicates that DNS implementations must publish the notReadyAddresses of subsets for the Endpoints associated with the Service. The default value is false. The primary use case for setting this field is to use a StatefulSet's Headless Service to propagate SRV records for its Pods without respect to their readiness for purpose of peer discovery.",
                                type: 'boolean',
                              },
                              selector: {
                                additionalProperties: {
                                  type: 'string',
                                },
                                description: 'Route service traffic to pods with label keys and values matching this selector. If empty or not present, the service is assumed to have an external process managing its endpoints, which Kubernetes will not modify. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName. More info: https://kubernetes.io/docs/concepts/services-networking/service/',
                                type: 'object',
                              },
                              sessionAffinity: {
                                description: 'Supports "ClientIP" and "None". Used to maintain session affinity. Enable client IP based session affinity. Must be ClientIP or None. Defaults to None. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                type: 'string',
                              },
                              sessionAffinityConfig: {
                                description: 'sessionAffinityConfig contains the configurations of session affinity.',
                                properties: {
                                  clientIP: {
                                    description: 'clientIP contains the configurations of Client IP based session affinity.',
                                    properties: {
                                      timeoutSeconds: {
                                        description: 'timeoutSeconds specifies the seconds of ClientIP type session sticky time. The value must be >0 && <=86400(for 1 day) if ServiceAffinity == "ClientIP". Default value is 10800(for 3 hours).',
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                    },
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: {
                                description: 'type determines how the Service is exposed. Defaults to ClusterIP. Valid options are ExternalName, ClusterIP, NodePort, and LoadBalancer. "ExternalName" maps to the specified externalName. "ClusterIP" allocates a cluster-internal IP address for load-balancing to endpoints. Endpoints are determined by the selector or if that is not specified, by manual construction of an Endpoints object. If clusterIP is "None", no virtual IP is allocated and the endpoints are published as a set of endpoints rather than a stable IP. "NodePort" builds on ClusterIP and allocates a port on every node which routes to the clusterIP. "LoadBalancer" builds on NodePort and creates an external load-balancer (if supported in the current cloud) which routes to the clusterIP. More info: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      tls: {
                        description: 'TLS describe additional options to consider when generating HTTP TLS certificates.',
                        properties: {
                          certificate: {
                            description: 'Certificate is a reference to a secret that contains the certificate and private key to be used. \n The secret should have the following content: \n - `ca.crt`: The certificate authority (optional) - `tls.crt`: The certificate (or a chain). - `tls.key`: The private key to the first certificate in the certificate chain.',
                            properties: {
                              secretName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          selfSignedCertificate: {
                            description: 'SelfSignedCertificate define options to apply to self-signed certificate managed by the operator.',
                            properties: {
                              disabled: {
                                description: 'Disabled turns off the provisioning of self-signed HTTP TLS certificates.',
                                type: 'boolean',
                              },
                              subjectAltNames: {
                                description: 'SubjectAlternativeNames is a list of SANs to include in the HTTP TLS certificates. For example: a wildcard DNS to expose the cluster.',
                                items: {
                                  properties: {
                                    dns: {
                                      type: 'string',
                                    },
                                    ip: {
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
                    type: 'object',
                  },
                  image: {
                    description: 'Image represents the docker image that will be used.',
                    type: 'string',
                  },
                  nodes: {
                    description: 'Nodes represents a list of groups of nodes with the same configuration to be part of the cluster',
                    items: {
                      description: 'NodeSpec defines a common topology for a set of Elasticsearch nodes',
                      properties: {
                        config: {
                          description: 'Config represents Elasticsearch configuration.',
                          type: 'object',
                        },
                        name: {
                          description: 'Name is a logical name for this set of nodes. Used as a part of the managed Elasticsearch node.name setting.',
                          maxLength: 23,
                          pattern: '[a-zA-Z0-9-]+',
                          type: 'string',
                        },
                        nodeCount: {
                          description: 'NodeCount defines how many nodes have this topology',
                          format: 'int32',
                          type: 'integer',
                        },
                        volumeClaimTemplates: {
                          description: 'VolumeClaimTemplates is a list of claims that pods are allowed to reference. Every claim in this list must have at least one matching (by name) volumeMount in one container in the template. A claim in this list takes precedence over any volumes in the template, with the same name. TODO: Define the behavior if a claim already exists with the same name. TODO: define special behavior based on claim metadata.name. (e.g data / logs volumes)',
                          items: {
                            description: "PersistentVolumeClaim is a user's request for and claim to a persistent volume",
                            properties: {
                              apiVersion: {
                                description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources',
                                type: 'string',
                              },
                              kind: {
                                description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds',
                                type: 'string',
                              },
                              metadata: {
                                description: "Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata",
                                type: 'object',
                              },
                              spec: {
                                description: 'Spec defines the desired characteristics of a volume requested by a pod author. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims',
                                properties: {
                                  accessModes: {
                                    description: 'AccessModes contains the desired access modes the volume should have. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1',
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                  dataSource: {
                                    description: 'This field requires the VolumeSnapshotDataSource alpha feature gate to be enabled and currently VolumeSnapshot is the only supported data source. If the provisioner can support VolumeSnapshot data source, it will create a new volume and data will be restored to the volume at the same time. If the provisioner does not support VolumeSnapshot data source, volume will not be created and the failure will be reported as an event. In the future, we plan to support more data source types and the behavior of the provisioner may change.',
                                    properties: {
                                      apiGroup: {
                                        description: 'APIGroup is the group for the resource being referenced. If APIGroup is not specified, the specified Kind must be in the core API group. For any other third-party types, APIGroup is required.',
                                        type: 'string',
                                      },
                                      kind: {
                                        description: 'Kind is the type of resource being referenced',
                                        type: 'string',
                                      },
                                      name: {
                                        description: 'Name is the name of resource being referenced',
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'kind',
                                      'name',
                                    ],
                                    type: 'object',
                                  },
                                  resources: {
                                    description: 'Resources represents the minimum resources the volume should have. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#resources',
                                    properties: {
                                      limits: {
                                        additionalProperties: {
                                          type: 'string',
                                        },
                                        description: 'Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/',
                                        type: 'object',
                                      },
                                      requests: {
                                        additionalProperties: {
                                          type: 'string',
                                        },
                                        description: 'Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/',
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  selector: {
                                    description: 'A label query over volumes to consider for binding.',
                                    properties: {
                                      matchExpressions: {
                                        description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                        items: {
                                          description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                          properties: {
                                            key: {
                                              description: 'key is the label key that the selector applies to.',
                                              type: 'string',
                                            },
                                            operator: {
                                              description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                              type: 'string',
                                            },
                                            values: {
                                              description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
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
                                        description: 'matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.',
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  storageClassName: {
                                    description: 'Name of the StorageClass required by the claim. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1',
                                    type: 'string',
                                  },
                                  volumeMode: {
                                    description: 'volumeMode defines what type of volume is required by the claim. Value of Filesystem is implied when not included in claim spec. This is a beta feature.',
                                    type: 'string',
                                  },
                                  volumeName: {
                                    description: 'VolumeName is the binding reference to the PersistentVolume backing this claim.',
                                    type: 'string',
                                  },
                                },
                                type: 'object',
                              },
                              status: {
                                description: 'Status represents the current information/status of a persistent volume claim. Read-only. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims',
                                properties: {
                                  accessModes: {
                                    description: 'AccessModes contains the actual access modes the volume backing the PVC has. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1',
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                  capacity: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: 'Represents the actual resources of the underlying volume.',
                                    type: 'object',
                                  },
                                  conditions: {
                                    description: "Current Condition of persistent volume claim. If underlying persistent volume is being resized then the Condition will be set to 'ResizeStarted'.",
                                    items: {
                                      description: 'PersistentVolumeClaimCondition contails details about state of pvc',
                                      properties: {
                                        lastProbeTime: {
                                          description: 'Last time we probed the condition.',
                                          format: 'date-time',
                                          type: 'string',
                                        },
                                        lastTransitionTime: {
                                          description: 'Last time the condition transitioned from one status to another.',
                                          format: 'date-time',
                                          type: 'string',
                                        },
                                        message: {
                                          description: 'Human-readable message indicating details about last transition.',
                                          type: 'string',
                                        },
                                        reason: {
                                          description: "Unique, this should be a short, machine understandable string that gives the reason for condition's last transition. If it reports \"ResizeStarted\" that means the underlying persistent volume is being resized.",
                                          type: 'string',
                                        },
                                        status: {
                                          type: 'string',
                                        },
                                        type: {
                                          description: 'PersistentVolumeClaimConditionType is a valid value of PersistentVolumeClaimCondition.Type',
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'status',
                                        'type',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  phase: {
                                    description: 'Phase represents the current phase of PersistentVolumeClaim.',
                                    type: 'string',
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
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  podDisruptionBudget: {
                    description: 'PodDisruptionBudget allows full control of the default pod disruption budget. \n The default budget selects all cluster pods and sets maxUnavailable to 1. To disable it entirely, set to the empty value (`{}` in YAML).',
                    properties: {
                      metadata: {
                        description: 'ObjectMeta is metadata for the service. The name and namespace provided here is managed by ECK and will be ignored.',
                        type: 'object',
                      },
                      spec: {
                        description: 'Spec of the desired behavior of the PodDisruptionBudget',
                        properties: {
                          maxUnavailable: {
                            anyOf: [
                              {
                                type: 'string',
                              },
                              {
                                type: 'integer',
                              },
                            ],
                            description: 'An eviction is allowed if at most "maxUnavailable" pods selected by "selector" are unavailable after the eviction, i.e. even in absence of the evicted pod. For example, one can prevent all voluntary evictions by specifying 0. This is a mutually exclusive setting with "minAvailable".',
                          },
                          minAvailable: {
                            anyOf: [
                              {
                                type: 'string',
                              },
                              {
                                type: 'integer',
                              },
                            ],
                            description: 'An eviction is allowed if at least "minAvailable" pods selected by "selector" will still be available after the eviction, i.e. even in the absence of the evicted pod.  So for example you can prevent all voluntary evictions by specifying "100%".',
                          },
                          selector: {
                            description: 'Label query over pods whose evictions are managed by the disruption budget.',
                            properties: {
                              matchExpressions: {
                                description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                items: {
                                  description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                  properties: {
                                    key: {
                                      description: 'key is the label key that the selector applies to.',
                                      type: 'string',
                                    },
                                    operator: {
                                      description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                      type: 'string',
                                    },
                                    values: {
                                      description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
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
                                description: 'matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.',
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
                  secureSettings: {
                    description: 'SecureSettings references secrets containing secure settings, to be injected into Elasticsearch keystore on each node. Each individual key/value entry in the referenced secrets is considered as an individual secure setting to be injected. You can use the `entries` and `key` fields to consider only a subset of the secret entries and the `path` field to change the target path of a secret entry key. The secret must exist in the same namespace as the Elasticsearch resource.',
                    items: {
                      properties: {
                        entries: {
                          description: 'If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present.',
                          items: {
                            description: 'Maps a string key to a path within a volume.',
                            properties: {
                              key: {
                                description: 'The key to project.',
                                type: 'string',
                              },
                              path: {
                                description: "The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.",
                                type: 'string',
                              },
                            },
                            required: [
                              'key',
                            ],
                            type: 'object',
                          },
                          type: 'array',
                        },
                        secretName: {
                          description: "Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret",
                          type: 'string',
                        },
                      },
                      required: [
                        'secretName',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  updateStrategy: {
                    description: 'UpdateStrategy specifies how updates to the cluster should be performed.',
                    properties: {
                      changeBudget: {
                        description: 'ChangeBudget is the change budget that should be used when performing mutations to the cluster.',
                        properties: {
                          maxSurge: {
                            description: 'MaxSurge is the maximum number of pods that can be scheduled above the original number of pods. By default, a fixed value of 1 is used. Value can be an absolute number (ex: 5) or a percentage of total pods at the start of the update (ex: 10%). This can not be 0 if MaxUnavailable is 0 if you want automatic rolling updates to be applied. Absolute number is calculated from percentage by rounding up. Example: when this is set to 30%, the new group can be scaled up by 30% immediately when the rolling update starts. Once old pods have been killed, new group can be scaled up further, ensuring that total number of pods running at any time during the update is at most 130% of the target number of pods.',
                            type: 'integer',
                          },
                          maxUnavailable: {
                            description: 'MaxUnavailable is the maximum number of pods that can be unavailable during the update. Value can be an absolute number (ex: 5) or a percentage of total pods at the start of update (ex: 10%). Absolute number is calculated from percentage by rounding down. This can not be 0 if MaxSurge is 0 if you want automatic rolling changes to be applied. By default, a fixed value of 0 is used. Example: when this is set to 30%, the group can be scaled down by 30% immediately when the rolling update starts. Once new pods are ready, the group can be scaled down further, followed by scaling up the group, ensuring that at least 70% of the target number of pods are available at all times during the update.',
                            type: 'integer',
                          },
                        },
                        required: [
                          'maxSurge',
                          'maxUnavailable',
                        ],
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  version: {
                    description: 'Version represents the version of the stack',
                    type: 'string',
                  },
                },
                type: 'object',
              },
              status: {
                description: 'ElasticsearchStatus defines the observed state of Elasticsearch',
                properties: {
                  availableNodes: {
                    type: 'integer',
                  },
                  clusterUUID: {
                    type: 'string',
                  },
                  health: {
                    description: 'ElasticsearchHealth is the health of the cluster as returned by the health API.',
                    type: 'string',
                  },
                  masterNode: {
                    type: 'string',
                  },
                  phase: {
                    description: 'ElasticsearchOrchestrationPhase is the phase Elasticsearch is in from the controller point of view.',
                    type: 'string',
                  },
                  service: {
                    type: 'string',
                  },
                  zenDiscovery: {
                    properties: {
                      minimumMasterNodes: {
                        type: 'integer',
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
        served: true,
        storage: false,
      },
      {
        name: 'v1beta1',
        schema: {
          openAPIV3Schema: {
            description: 'Elasticsearch is the Schema for the elasticsearches API',
            properties: {
              apiVersion: {
                description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources',
                type: 'string',
              },
              kind: {
                description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds',
                type: 'string',
              },
              metadata: {
                type: 'object',
              },
              spec: {
                description: 'ElasticsearchSpec defines the desired state of Elasticsearch',
                properties: {
                  http: {
                    description: 'HTTP contains settings for HTTP.',
                    properties: {
                      service: {
                        description: 'Service is a template for the Kubernetes Service',
                        properties: {
                          metadata: {
                            description: 'ObjectMeta is metadata for the service. The name and namespace provided here is managed by ECK and will be ignored.',
                            type: 'object',
                          },
                          spec: {
                            description: 'Spec defines the behavior of the service.',
                            properties: {
                              clusterIP: {
                                description: 'clusterIP is the IP address of the service and is usually assigned randomly by the master. If an address is specified manually and is not in use by others, it will be allocated to the service; otherwise, creation of the service will fail. This field can not be changed through updates. Valid values are "None", empty string (""), or a valid IP address. "None" can be specified for headless services when proxying is not required. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                type: 'string',
                              },
                              externalIPs: {
                                description: 'externalIPs is a list of IP addresses for which nodes in the cluster will also accept traffic for this service.  These IPs are not managed by Kubernetes.  The user is responsible for ensuring that traffic arrives at a node with this IP.  A common example is external load-balancers that are not part of the Kubernetes system.',
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                              externalName: {
                                description: 'externalName is the external reference that kubedns or equivalent will return as a CNAME record for this service. No proxying will be involved. Must be a valid RFC-1123 hostname (https://tools.ietf.org/html/rfc1123) and requires Type to be ExternalName.',
                                type: 'string',
                              },
                              externalTrafficPolicy: {
                                description: 'externalTrafficPolicy denotes if this Service desires to route external traffic to node-local or cluster-wide endpoints. "Local" preserves the client source IP and avoids a second hop for LoadBalancer and Nodeport type services, but risks potentially imbalanced traffic spreading. "Cluster" obscures the client source IP and may cause a second hop to another node, but should have good overall load-spreading.',
                                type: 'string',
                              },
                              healthCheckNodePort: {
                                description: 'healthCheckNodePort specifies the healthcheck nodePort for the service. If not specified, HealthCheckNodePort is created by the service api backend with the allocated nodePort. Will use user-specified nodePort value if specified by the client. Only effects when Type is set to LoadBalancer and ExternalTrafficPolicy is set to Local.',
                                format: 'int32',
                                type: 'integer',
                              },
                              loadBalancerIP: {
                                description: 'Only applies to Service Type: LoadBalancer LoadBalancer will get created with the IP specified in this field. This feature depends on whether the underlying cloud-provider supports specifying the loadBalancerIP when a load balancer is created. This field will be ignored if the cloud-provider does not support the feature.',
                                type: 'string',
                              },
                              loadBalancerSourceRanges: {
                                description: 'If specified and supported by the platform, this will restrict traffic through the cloud-provider load-balancer will be restricted to the specified client IPs. This field will be ignored if the cloud-provider does not support the feature." More info: https://kubernetes.io/docs/tasks/access-application-cluster/configure-cloud-provider-firewall/',
                                items: {
                                  type: 'string',
                                },
                                type: 'array',
                              },
                              ports: {
                                description: 'The list of ports that are exposed by this service. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                items: {
                                  description: "ServicePort contains information on service's port.",
                                  properties: {
                                    name: {
                                      description: "The name of this port within the service. This must be a DNS_LABEL. All ports within a ServiceSpec must have unique names. This maps to the 'Name' field in EndpointPort objects. Optional if only one ServicePort is defined on this service.",
                                      type: 'string',
                                    },
                                    nodePort: {
                                      description: 'The port on each node on which this service is exposed when type=NodePort or LoadBalancer. Usually assigned by the system. If specified, it will be allocated to the service if unused or else creation of the service will fail. Default is to auto-allocate a port if the ServiceType of this Service requires one. More info: https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport',
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                    port: {
                                      description: 'The port that will be exposed by this service.',
                                      format: 'int32',
                                      type: 'integer',
                                    },
                                    protocol: {
                                      description: 'The IP protocol for this port. Supports "TCP", "UDP", and "SCTP". Default is TCP.',
                                      type: 'string',
                                    },
                                    targetPort: {
                                      anyOf: [
                                        {
                                          type: 'string',
                                        },
                                        {
                                          type: 'integer',
                                        },
                                      ],
                                      description: "Number or name of the port to access on the pods targeted by the service. Number must be in the range 1 to 65535. Name must be an IANA_SVC_NAME. If this is a string, it will be looked up as a named port in the target Pod's container ports. If this is not specified, the value of the 'port' field is used (an identity map). This field is ignored for services with clusterIP=None, and should be omitted or set equal to the 'port' field. More info: https://kubernetes.io/docs/concepts/services-networking/service/#defining-a-service",
                                    },
                                  },
                                  required: [
                                    'port',
                                  ],
                                  type: 'object',
                                },
                                type: 'array',
                              },
                              publishNotReadyAddresses: {
                                description: "publishNotReadyAddresses, when set to true, indicates that DNS implementations must publish the notReadyAddresses of subsets for the Endpoints associated with the Service. The default value is false. The primary use case for setting this field is to use a StatefulSet's Headless Service to propagate SRV records for its Pods without respect to their readiness for purpose of peer discovery.",
                                type: 'boolean',
                              },
                              selector: {
                                additionalProperties: {
                                  type: 'string',
                                },
                                description: 'Route service traffic to pods with label keys and values matching this selector. If empty or not present, the service is assumed to have an external process managing its endpoints, which Kubernetes will not modify. Only applies to types ClusterIP, NodePort, and LoadBalancer. Ignored if type is ExternalName. More info: https://kubernetes.io/docs/concepts/services-networking/service/',
                                type: 'object',
                              },
                              sessionAffinity: {
                                description: 'Supports "ClientIP" and "None". Used to maintain session affinity. Enable client IP based session affinity. Must be ClientIP or None. Defaults to None. More info: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies',
                                type: 'string',
                              },
                              sessionAffinityConfig: {
                                description: 'sessionAffinityConfig contains the configurations of session affinity.',
                                properties: {
                                  clientIP: {
                                    description: 'clientIP contains the configurations of Client IP based session affinity.',
                                    properties: {
                                      timeoutSeconds: {
                                        description: 'timeoutSeconds specifies the seconds of ClientIP type session sticky time. The value must be >0 && <=86400(for 1 day) if ServiceAffinity == "ClientIP". Default value is 10800(for 3 hours).',
                                        format: 'int32',
                                        type: 'integer',
                                      },
                                    },
                                    type: 'object',
                                  },
                                },
                                type: 'object',
                              },
                              type: {
                                description: 'type determines how the Service is exposed. Defaults to ClusterIP. Valid options are ExternalName, ClusterIP, NodePort, and LoadBalancer. "ExternalName" maps to the specified externalName. "ClusterIP" allocates a cluster-internal IP address for load-balancing to endpoints. Endpoints are determined by the selector or if that is not specified, by manual construction of an Endpoints object. If clusterIP is "None", no virtual IP is allocated and the endpoints are published as a set of endpoints rather than a stable IP. "NodePort" builds on ClusterIP and allocates a port on every node which routes to the clusterIP. "LoadBalancer" builds on NodePort and creates an external load-balancer (if supported in the current cloud) which routes to the clusterIP. More info: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types',
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                        },
                        type: 'object',
                      },
                      tls: {
                        description: 'TLS describe additional options to consider when generating HTTP TLS certificates.',
                        properties: {
                          certificate: {
                            description: 'Certificate is a reference to a secret that contains the certificate and private key to be used. \n The secret should have the following content: \n - `ca.crt`: The certificate authority (optional) - `tls.crt`: The certificate (or a chain). - `tls.key`: The private key to the first certificate in the certificate chain.',
                            properties: {
                              secretName: {
                                type: 'string',
                              },
                            },
                            type: 'object',
                          },
                          selfSignedCertificate: {
                            description: 'SelfSignedCertificate define options to apply to self-signed certificate managed by the operator.',
                            properties: {
                              disabled: {
                                description: 'Disabled turns off the provisioning of self-signed HTTP TLS certificates.',
                                type: 'boolean',
                              },
                              subjectAltNames: {
                                description: 'SubjectAlternativeNames is a list of SANs to include in the HTTP TLS certificates. For example: a wildcard DNS to expose the cluster.',
                                items: {
                                  properties: {
                                    dns: {
                                      type: 'string',
                                    },
                                    ip: {
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
                    type: 'object',
                  },
                  image: {
                    description: 'Image represents the docker image that will be used.',
                    type: 'string',
                  },
                  nodeSets: {
                    description: 'NodeSets represents a list of groups of nodes with the same configuration to be part of the cluster',
                    items: {
                      description: 'NodeSet defines a common topology for a set of Elasticsearch nodes',
                      properties: {
                        config: {
                          description: 'Config represents Elasticsearch configuration.',
                          type: 'object',
                        },
                        count: {
                          description: 'Count defines how many nodes this topology should have.',
                          format: 'int32',
                          type: 'integer',
                        },
                        name: {
                          description: 'Name is a logical name for this set of nodes. Used as a part of the managed Elasticsearch node.name setting.',
                          maxLength: 23,
                          pattern: '[a-zA-Z0-9-]+',
                          type: 'string',
                        },
                        volumeClaimTemplates: {
                          description: 'VolumeClaimTemplates is a list of claims that pods are allowed to reference. Every claim in this list must have at least one matching (by name) volumeMount in one container in the template. A claim in this list takes precedence over any volumes in the template, with the same name. TODO: Define the behavior if a claim already exists with the same name. TODO: define special behavior based on claim metadata.name. (e.g data / logs volumes)',
                          items: {
                            description: "PersistentVolumeClaim is a user's request for and claim to a persistent volume",
                            properties: {
                              apiVersion: {
                                description: 'APIVersion defines the versioned schema of this representation of an object. Servers should convert recognized schemas to the latest internal value, and may reject unrecognized values. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#resources',
                                type: 'string',
                              },
                              kind: {
                                description: 'Kind is a string value representing the REST resource this object represents. Servers may infer this from the endpoint the client submits requests to. Cannot be updated. In CamelCase. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds',
                                type: 'string',
                              },
                              metadata: {
                                description: "Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata",
                                type: 'object',
                              },
                              spec: {
                                description: 'Spec defines the desired characteristics of a volume requested by a pod author. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims',
                                properties: {
                                  accessModes: {
                                    description: 'AccessModes contains the desired access modes the volume should have. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1',
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                  dataSource: {
                                    description: 'This field requires the VolumeSnapshotDataSource alpha feature gate to be enabled and currently VolumeSnapshot is the only supported data source. If the provisioner can support VolumeSnapshot data source, it will create a new volume and data will be restored to the volume at the same time. If the provisioner does not support VolumeSnapshot data source, volume will not be created and the failure will be reported as an event. In the future, we plan to support more data source types and the behavior of the provisioner may change.',
                                    properties: {
                                      apiGroup: {
                                        description: 'APIGroup is the group for the resource being referenced. If APIGroup is not specified, the specified Kind must be in the core API group. For any other third-party types, APIGroup is required.',
                                        type: 'string',
                                      },
                                      kind: {
                                        description: 'Kind is the type of resource being referenced',
                                        type: 'string',
                                      },
                                      name: {
                                        description: 'Name is the name of resource being referenced',
                                        type: 'string',
                                      },
                                    },
                                    required: [
                                      'kind',
                                      'name',
                                    ],
                                    type: 'object',
                                  },
                                  resources: {
                                    description: 'Resources represents the minimum resources the volume should have. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#resources',
                                    properties: {
                                      limits: {
                                        additionalProperties: {
                                          type: 'string',
                                        },
                                        description: 'Limits describes the maximum amount of compute resources allowed. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/',
                                        type: 'object',
                                      },
                                      requests: {
                                        additionalProperties: {
                                          type: 'string',
                                        },
                                        description: 'Requests describes the minimum amount of compute resources required. If Requests is omitted for a container, it defaults to Limits if that is explicitly specified, otherwise to an implementation-defined value. More info: https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/',
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  selector: {
                                    description: 'A label query over volumes to consider for binding.',
                                    properties: {
                                      matchExpressions: {
                                        description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                        items: {
                                          description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                          properties: {
                                            key: {
                                              description: 'key is the label key that the selector applies to.',
                                              type: 'string',
                                            },
                                            operator: {
                                              description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                              type: 'string',
                                            },
                                            values: {
                                              description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
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
                                        description: 'matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.',
                                        type: 'object',
                                      },
                                    },
                                    type: 'object',
                                  },
                                  storageClassName: {
                                    description: 'Name of the StorageClass required by the claim. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1',
                                    type: 'string',
                                  },
                                  volumeMode: {
                                    description: 'volumeMode defines what type of volume is required by the claim. Value of Filesystem is implied when not included in claim spec. This is a beta feature.',
                                    type: 'string',
                                  },
                                  volumeName: {
                                    description: 'VolumeName is the binding reference to the PersistentVolume backing this claim.',
                                    type: 'string',
                                  },
                                },
                                type: 'object',
                              },
                              status: {
                                description: 'Status represents the current information/status of a persistent volume claim. Read-only. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims',
                                properties: {
                                  accessModes: {
                                    description: 'AccessModes contains the actual access modes the volume backing the PVC has. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1',
                                    items: {
                                      type: 'string',
                                    },
                                    type: 'array',
                                  },
                                  capacity: {
                                    additionalProperties: {
                                      type: 'string',
                                    },
                                    description: 'Represents the actual resources of the underlying volume.',
                                    type: 'object',
                                  },
                                  conditions: {
                                    description: "Current Condition of persistent volume claim. If underlying persistent volume is being resized then the Condition will be set to 'ResizeStarted'.",
                                    items: {
                                      description: 'PersistentVolumeClaimCondition contails details about state of pvc',
                                      properties: {
                                        lastProbeTime: {
                                          description: 'Last time we probed the condition.',
                                          format: 'date-time',
                                          type: 'string',
                                        },
                                        lastTransitionTime: {
                                          description: 'Last time the condition transitioned from one status to another.',
                                          format: 'date-time',
                                          type: 'string',
                                        },
                                        message: {
                                          description: 'Human-readable message indicating details about last transition.',
                                          type: 'string',
                                        },
                                        reason: {
                                          description: "Unique, this should be a short, machine understandable string that gives the reason for condition's last transition. If it reports \"ResizeStarted\" that means the underlying persistent volume is being resized.",
                                          type: 'string',
                                        },
                                        status: {
                                          type: 'string',
                                        },
                                        type: {
                                          description: 'PersistentVolumeClaimConditionType is a valid value of PersistentVolumeClaimCondition.Type',
                                          type: 'string',
                                        },
                                      },
                                      required: [
                                        'status',
                                        'type',
                                      ],
                                      type: 'object',
                                    },
                                    type: 'array',
                                  },
                                  phase: {
                                    description: 'Phase represents the current phase of PersistentVolumeClaim.',
                                    type: 'string',
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
                      required: [
                        'name',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  podDisruptionBudget: {
                    description: 'PodDisruptionBudget allows full control of the default pod disruption budget. \n The default budget selects all cluster pods and sets maxUnavailable to 1. To disable it entirely, set to the empty value (`{}` in YAML).',
                    properties: {
                      metadata: {
                        description: 'ObjectMeta is metadata for the service. The name and namespace provided here is managed by ECK and will be ignored.',
                        type: 'object',
                      },
                      spec: {
                        description: 'Spec of the desired behavior of the PodDisruptionBudget',
                        properties: {
                          maxUnavailable: {
                            anyOf: [
                              {
                                type: 'string',
                              },
                              {
                                type: 'integer',
                              },
                            ],
                            description: 'An eviction is allowed if at most "maxUnavailable" pods selected by "selector" are unavailable after the eviction, i.e. even in absence of the evicted pod. For example, one can prevent all voluntary evictions by specifying 0. This is a mutually exclusive setting with "minAvailable".',
                          },
                          minAvailable: {
                            anyOf: [
                              {
                                type: 'string',
                              },
                              {
                                type: 'integer',
                              },
                            ],
                            description: 'An eviction is allowed if at least "minAvailable" pods selected by "selector" will still be available after the eviction, i.e. even in the absence of the evicted pod.  So for example you can prevent all voluntary evictions by specifying "100%".',
                          },
                          selector: {
                            description: 'Label query over pods whose evictions are managed by the disruption budget.',
                            properties: {
                              matchExpressions: {
                                description: 'matchExpressions is a list of label selector requirements. The requirements are ANDed.',
                                items: {
                                  description: 'A label selector requirement is a selector that contains values, a key, and an operator that relates the key and values.',
                                  properties: {
                                    key: {
                                      description: 'key is the label key that the selector applies to.',
                                      type: 'string',
                                    },
                                    operator: {
                                      description: "operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.",
                                      type: 'string',
                                    },
                                    values: {
                                      description: 'values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.',
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
                                description: 'matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.',
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
                  secureSettings: {
                    description: 'SecureSettings references secrets containing secure settings, to be injected into Elasticsearch keystore on each node. Each individual key/value entry in the referenced secrets is considered as an individual secure setting to be injected. You can use the `entries` and `key` fields to consider only a subset of the secret entries and the `path` field to change the target path of a secret entry key. The secret must exist in the same namespace as the Elasticsearch resource.',
                    items: {
                      properties: {
                        entries: {
                          description: 'If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present.',
                          items: {
                            description: 'Maps a string key to a path within a volume.',
                            properties: {
                              key: {
                                description: 'The key to project.',
                                type: 'string',
                              },
                              path: {
                                description: "The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.",
                                type: 'string',
                              },
                            },
                            required: [
                              'key',
                            ],
                            type: 'object',
                          },
                          type: 'array',
                        },
                        secretName: {
                          description: "Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret",
                          type: 'string',
                        },
                      },
                      required: [
                        'secretName',
                      ],
                      type: 'object',
                    },
                    type: 'array',
                  },
                  updateStrategy: {
                    description: 'UpdateStrategy specifies how updates to the cluster should be performed.',
                    properties: {
                      changeBudget: {
                        description: 'ChangeBudget is the change budget that should be used when performing mutations to the cluster.',
                        properties: {
                          maxSurge: {
                            description: "MaxSurge is the maximum number of pods that can be scheduled above the original number of pods. MaxSurge is only taken into the account when scaling up. Setting negative value will result in no restrictions on number of pods scheduled. By default, it's unbounded.",
                            format: 'int32',
                            type: 'integer',
                          },
                          maxUnavailable: {
                            description: 'MaxUnavailable is the maximum number of pods that can be unavailable (not ready) during the update due to the actions controlled by the operator. Setting negative value will result in no restrictions on number of unavailable pods. By default, a fixed value of 1 is used.',
                            format: 'int32',
                            type: 'integer',
                          },
                        },
                        type: 'object',
                      },
                    },
                    type: 'object',
                  },
                  version: {
                    description: 'Version represents the version of the stack',
                    type: 'string',
                  },
                },
                type: 'object',
              },
              status: {
                description: 'ElasticsearchStatus defines the observed state of Elasticsearch',
                properties: {
                  availableNodes: {
                    type: 'integer',
                  },
                  health: {
                    description: 'ElasticsearchHealth is the health of the cluster as returned by the health API.',
                    type: 'string',
                  },
                  phase: {
                    description: 'ElasticsearchOrchestrationPhase is the phase Elasticsearch is in from the controller point of view.',
                    type: 'string',
                  },
                },
                type: 'object',
              },
            },
            type: 'object',
          },
        },
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
