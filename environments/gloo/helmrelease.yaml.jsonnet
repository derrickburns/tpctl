local lib = import '../../lib/lib.jsonnet';

local baseGatewayProxy = {
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
    },
    httpPort: 8080,
    httpsPort: 8443,
    runAsUser: 10101,
    extraAnnotations: {
      'linkerd.io/inject': 'enabled',
    },
  },
  service: {
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
};

local helmrelease(config, namespace) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    annotations: {
      'fluxcd.io/automated': 'false',
    },
    name: 'gloo',
    namespace: 'test',
  },
  spec: {
    chart: {
      name: 'gloo',
      repository: 'https://storage.googleapis.com/solo-public-helm/',
      version: config.pkgs.gloo.version,
    },
    releaseName: 'test-gloo',
  },
  values: {
    global: {
      image: {
        tag: config.pkgs.gloo.version,
      },
    },
    settings: {
      linkerd: true,
      singleNamespace: true,
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
        replicas: 1,
      },
      enabled: true,
    },
    gatewayProxies: {
      internalGatewayProxy: baseGatewayProxy {
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        service: {
          type: 'ClusterIP',
        },
      },
      gatewayProxy: baseGatewayProxy {
        kind: {
          deployment: {
            replicas: 2,
          },
        },
        service: {
          type: 'LoadBalancer',
          extraAnnotations: {
            'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
            'external-dns.alpha.kubernetes.io/alias': 'true',
            'external-dns.alpha.kubernetes.io/hostname': config.environments[namespace].tidepool.dnsNames,
            'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
          },
        },
      },
    },
  },
};

function(config, prev, namespace) helmrelease(config,namespace)
