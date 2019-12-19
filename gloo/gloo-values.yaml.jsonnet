local lib = import '../lib/lib.jsonnet';

local tracing = import '../pkgs/tracing/lib.jsonnet';

local baseGatewayProxy(config, name) = {
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
      'configmap.reloader.stakater.com/reload': '%s-envoy-config' % name
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
      name: 'envoy.tracers.opencensus',
      typed_config: {
        '@type': 'type.googleapis.com/envoy.config.trace.v2.OpenCensusConfig',
        ocagent_exporter_enabled: true,
        ocagent_address: tracing.address(config),
        incoming_trace_context: 'b3',
        outgoing_trace_context: 'b3',
      },
    },
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
      tag: config.pkgs.gloo.version,
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
    internalGatewayProxy: baseGatewayProxy(config, 'internal-gateway-proxy') {
      service+: {
        type: 'ClusterIP',
      },
    },
    gatewayProxy: baseGatewayProxy(config, 'gateway-proxy') {
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
