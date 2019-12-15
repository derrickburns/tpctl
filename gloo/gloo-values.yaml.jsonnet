local lib = import '../lib/lib.jsonnet';

local values(config) = {
  rateLimit: {
    enabled: false
  },
  gloo: {
    crds: {
      create: true
    },
    global: {
      image: {
        tag: "1.0.0-rc5",
      },
    },
    namespace: {
      create: false,
    },  
    gloo: {
      deployment: {
        disableUsageStatistics: false,
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          repository: 'gloo-ee',
          tag: '1.0.0-rc5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: true,
        validationPort: 9988,
        xdsPort: 9977,
      },
    },
    discovery: {
      deployment: {
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'discovery',
          tag: '1.2.5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: false,
      },
      enabled: true,
      fdsMode: '',
    },
    gateway: {
      certGenJob: {
        enabled: true,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'certgen',
          tag: '1.2.5',
        },
        restartPolicy: 'OnFailure',
        setTtlAfterFinished: true,
        ttlSecondsAfterFinished: 60,
      },
      deployment: {
        floatingUserId: false,
        image: {
          pullPolicy: 'IfNotPresent',
          registry: 'quay.io/solo-io',
          repository: 'gateway',
          tag: '1.2.5',
        },
        replicas: 1,
        runAsUser: 10101,
        stats: false,
      },
      enabled: true,
      proxyServiceAccount: {
        disableAutomount: false,
      },
      readGatewaysFromAllNamespaces: false,
      updateValues: true,
      validation: {
        alwaysAcceptResources: true,
        enabled: true,
        failurePolicy: 'Ignore',
        secretName: 'gateway-validation-certs',
      },
    },
    gatewayProxies: {
      internalGatewayProxy: {
        antiAffinity: false,
        extraInitContainersHelper: '',
        extraVolumeHelper: '',
        stats: true,
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        configMap: {
          data: null,
        },
        podTemplate: {
          probes: false,
          disableNetBind: false,
          floatingUserId: false,
          httpPort: 8080,
          httpsPort: 8443,
          image: {
            pullPolicy: 'IfNotPresent',
            repository: 'gloo-ee-envoy-wrapper',
            tag: '1.0.0-rc5',
          },
          runAsUser: 0,
          runUnprivileged: false,
          tolerations: null,
          extraAnnotations: {
            'linkerd.io/inject': 'enabled',
            'config.linkerd.io/skip-inbound-ports': '8081',
          },
        },
        service: {
          type: 'ClusterIP',
          httpPort: 80,
          httpsPort: 443,
          extraAnnotations: {
            'prometheus.io/path': '/metrics',
            'prometheus.io/port': '8081',
            'prometheus.io/scrape': 'true',
          },
        },
        readConfig: true,
        gatewaySettings: {
          disableGeneratedGateways: true,
        },
        tracing: {
          provider: {
            name: 'envoy.zipkin',
            typed_config: {
              '@type': 'type.googleapis.com/envoy.config.trace.v2.ZipkinConfig',
              collector_cluster: 'zipkin',
              collector_endpoint: '/api/v1/spans',
            },
          },
          cluster: [
            {
              name: 'zipkin',
              connect_timeout: '1s',
              type: 'STRICT_DNS',
              load_assignment: {
                cluster_name: 'zipkin',
                endpoints: [
                  {
                    lb_endpoints: [
                      {
                        endpoint: {
                          address: {
                            socket_address: {
                              address: 'simplest-collector',
                              port_value: 9411,
                            },
                          },
                        },
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
      },
      gatewayProxy: {
        antiAffinity: false,
        extraInitContainersHelper: '',
        extraVolumeHelper: '',
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        readConfig: true,
        gatewaySettings: {
          disableGeneratedGateways: true,
        },
        configMap: {
          data: null,
        },
        tracing: {
          provider: {
            name: 'envoy.zipkin',
            typed_config: {
              '@type': 'type.googleapis.com/envoy.config.trace.v2.ZipkinConfig',
              collector_cluster: 'zipkin',
              collector_endpoint: '/api/v1/spans',
            },
          },
          cluster: [
            {
              name: 'zipkin',
              connect_timeout: '1s',
              type: 'STRICT_DNS',
              load_assignment: {
                cluster_name: 'zipkin',
                endpoints: [
                  {
                    lb_endpoints: [
                      {
                        endpoint: {
                          address: {
                            socket_address: {
                              address: 'simplest-collector',
                              port_value: 9411,
                            },
                          },
                        },
                      },
                    ],
                  },
                ],
              },
            },
          ],
        },
        podTemplate: {
          probes: false,
          disableNetBind: false,
          floatingUserId: false,
          httpPort: 8080,
          httpsPort: 8443,
          image: {
            pullPolicy: 'IfNotPresent',
            repository: 'gloo-ee-envoy-wrapper',
            tag: '1.0.0-rc5',
          },
          runAsUser: 0,
          runUnprivileged: false,
          tolerations: null,
          extraAnnotations: {
            'linkerd.io/inject': 'enabled',
            'config.linkerd.io/skip-inbound-ports': '8081',
          },
        },
        service: {
          type: 'LoadBalancer',
          httpPort: 80,
          httpsPort: 443,
          extraAnnotations: {
            'prometheus.io/path': '/metrics',
            'prometheus.io/port': '8081',
            'prometheus.io/scrape': 'true',
            'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
            'external-dns.alpha.kubernetes.io/alias': 'true',
            'external-dns.alpha.kubernetes.io/hostname': lib.dnsNames(config),
            'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,

          },
        },
      },
    },
    settings: {
      linkerd: true,
    },
  },
};


function(config) values(config)
