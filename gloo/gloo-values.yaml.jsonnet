local lib = import '../lib/lib.jsonnet';

local values(config) = {
  settings: {
    create: true,
    linkerd: true,
  },
  namespace: {
    create: false,
  },
  discovery: {
    enabled: true,
    fdsMode: 'WHITELIST',
  },
  gateway: {
    deployment: {
      image: {
        repository: 'gateway',
      },
      replicas: 1,
      runAsUser: 10101,
      stats: true,
    },
    enabled: true,
    proxyServiceAccount: {},
    upgrade: false,
    validation: {
      enabled: false,
      alwaysAcceptResources: true,
    },
  },
  gatewayProxies: {
    internalGatewayProxy: {
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
        image: {
          repository: 'gloo-envoy-wrapper',
          registry: 'quay.io/solo-io',
          tag: config.pkgs.gloo.version,
        },
        httpPort: 8080,
        httpsPort: 8443,
        runAsUser: 10101,
        extraAnnotations: {
          'linkerd.io/inject': 'enabled',
          'config.linkerd.io/skip-inbound-ports': '8081',
        },
      },
      service: {
        type: 'ClusterIP',
        httpPort: 80,
        httpsPort: 443,
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
        image: {
          repository: 'gloo-envoy-wrapper',
          registry: 'quay.io/solo-io',
          tag: config.pkgs.gloo.version,
        },
        httpPort: 8080,
        httpsPort: 8443,
        runAsUser: 10101,
        extraAnnotations: {
          'linkerd.io/inject': 'enabled',
          'config.linkerd.io/skip-inbound-ports': 8081,
        },
      },
      service: {
        type: 'LoadBalancer',
        httpPort: 80,
        httpsPort: 443,
        extraAnnotations: {
          //'service.beta.kubernetes.io/aws-load-balancer-type': 'nlb',
          'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': lib.dnsNames(config),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,

        },
      },
    },
  },
};

function(config) values(config)
