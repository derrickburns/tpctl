local lib = import '../lib/lib.jsonnet';

local baseGatewayProxy(config) = {
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
    disableNetBind: false,
    floatingUserId: false,
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
  tracing: if lib.getElse(config, 'pkgs.tracing.enabled', false) then {
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
                        address: '%s-collector.%s' % [
                          lib.getElse(config, 'pkgs.tracing.name', 'jaeger'),
                          lib.getElse(config, 'pkgs.tracing.namespace', 'tracing')],
                        port_value: lib.getElse(config, 'pkgs.jaeger.port', 9411),
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
  } else null,
};

local values(config) = {
  global: {
    glooRbac: {
      create: true,
    },
    image: {
      pullPolicy: 'IfNotPresent',
      registry: 'quay.io/solo-io',
    },
  },
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
      enabled: true,
      failurePolicy: "Ignore",
      secretName: "gateway-validation-certs",
      alwaysAcceptResources: true,
    },
  },
  gatewayProxies+: {
    internalGatewayProxy: baseGatewayProxy(config) {
      service+: {
        type: 'ClusterIP',
      },
    },
    gatewayProxy: baseGatewayProxy(config) {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+: {
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
