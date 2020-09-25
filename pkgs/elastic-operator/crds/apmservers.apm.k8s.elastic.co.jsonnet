{
  apiVersion: 'apiextensions.k8s.io/v1beta1',
  kind: 'CustomResourceDefinition',
  metadata: {
    creationTimestamp: null,
    name: 'apmservers.apm.k8s.elastic.co',
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
        description: 'APM version',
        name: 'version',
        type: 'string',
      },
      {
        JSONPath: '.metadata.creationTimestamp',
        name: 'age',
        type: 'date',
      },
    ],
    group: 'apm.k8s.elastic.co',
    names: {
      categories: [
        'elastic',
      ],
      kind: 'ApmServer',
      listKind: 'ApmServerList',
      plural: 'apmservers',
      shortNames: [
        'apm',
      ],
      singular: 'apmserver',
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
            description: 'ApmServer is the Schema for the apmservers API',
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
                description: 'ApmServerSpec defines the desired state of ApmServer',
                properties: {
                  config: {
                    description: 'Config represents the APM configuration.',
                    type: 'object',
                  },
                  elasticsearchRef: {
                    description: 'ElasticsearchRef references an Elasticsearch resource in the Kubernetes cluster. If the namespace is not specified, the current resource namespace will be used.',
                    properties: {
                      name: {
                        type: 'string',
                      },
                      namespace: {
                        type: 'string',
                      },
                    },
                    required: [
                      'name',
                    ],
                    type: 'object',
                  },
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
                  nodeCount: {
                    description: 'NodeCount defines how many nodes the Apm Server deployment must have.',
                    format: 'int32',
                    type: 'integer',
                  },
                  secureSettings: {
                    description: 'SecureSettings references secrets containing secure settings, to be injected into the APM keystore on each node. Each individual key/value entry in the referenced secrets is considered as an individual secure setting to be injected. You can use the `entries` and `key` fields to consider only a subset of the secret entries and the `path` field to change the target path of a secret entry key. The secret must exist in the same namespace as the APM resource.',
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
                  version: {
                    description: 'Version represents the version of the APM Server',
                    type: 'string',
                  },
                },
                type: 'object',
              },
              status: {
                description: 'ApmServerStatus defines the observed state of ApmServer',
                properties: {
                  associationStatus: {
                    description: 'Association is the status of any auto-linking to Elasticsearch clusters.',
                    type: 'string',
                  },
                  availableNodes: {
                    type: 'integer',
                  },
                  health: {
                    description: 'ApmServerHealth expresses the status of the Apm Server instances.',
                    type: 'string',
                  },
                  secretTokenSecret: {
                    description: 'SecretTokenSecretName is the name of the Secret that contains the secret token',
                    type: 'string',
                  },
                  service: {
                    description: 'ExternalService is the name of the service the agents should connect to.',
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
        storage: false,
      },
      {
        name: 'v1beta1',
        schema: {
          openAPIV3Schema: {
            description: 'ApmServer is the Schema for the apmservers API',
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
                description: 'ApmServerSpec defines the desired state of ApmServer',
                properties: {
                  config: {
                    description: 'Config represents the APM configuration.',
                    type: 'object',
                  },
                  count: {
                    description: 'Count defines how many nodes the Apm Server deployment must have.',
                    format: 'int32',
                    type: 'integer',
                  },
                  elasticsearchRef: {
                    description: 'ElasticsearchRef references an Elasticsearch resource in the Kubernetes cluster. If the namespace is not specified, the current resource namespace will be used.',
                    properties: {
                      name: {
                        type: 'string',
                      },
                      namespace: {
                        type: 'string',
                      },
                    },
                    required: [
                      'name',
                    ],
                    type: 'object',
                  },
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
                  secureSettings: {
                    description: 'SecureSettings references secrets containing secure settings, to be injected into the APM keystore on each node. Each individual key/value entry in the referenced secrets is considered as an individual secure setting to be injected. You can use the `entries` and `key` fields to consider only a subset of the secret entries and the `path` field to change the target path of a secret entry key. The secret must exist in the same namespace as the APM resource.',
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
                  version: {
                    description: 'Version represents the version of the APM Server',
                    type: 'string',
                  },
                },
                type: 'object',
              },
              status: {
                description: 'ApmServerStatus defines the observed state of ApmServer',
                properties: {
                  associationStatus: {
                    description: 'Association is the status of any auto-linking to Elasticsearch clusters.',
                    type: 'string',
                  },
                  availableNodes: {
                    type: 'integer',
                  },
                  health: {
                    description: 'ApmServerHealth expresses the status of the Apm Server instances.',
                    type: 'string',
                  },
                  secretTokenSecret: {
                    description: 'SecretTokenSecretName is the name of the Secret that contains the secret token',
                    type: 'string',
                  },
                  service: {
                    description: 'ExternalService is the name of the service the agents should connect to.',
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
