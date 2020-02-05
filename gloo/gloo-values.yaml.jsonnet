local lib = import '../lib/lib.jsonnet';
local linkerd = import '../pkgs/linkerd/lib.jsonnet';
local tracing = import '../pkgs/tracing/lib.jsonnet';
local pom = import '../pkgs/pomerium/lib.jsonnet';
local expand = import '../lib/expand.jsonnet';
local gloo = import '../lib/gloo.jsonnet';

local baseGatewayProxy(config, name) = {
  kind: {
    deployment: {
      replicas: lib.getElse(config, 'pkgs.gloo.proxies.' + name + '.replicas', 2),
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
    extraAnnotations: linkerd.annotations(config) + {
      'config.linkerd.io/skip-inbound-ports': 8081
    }
  },
  service: {
    httpPort: 80,
    httpsPort: 443,
  },
  readConfig: true,
  gatewaySettings: {
    disableGeneratedGateways: true,
  },
  tracing: tracing.envoy(config),
};

local values(config) = {
  global: {
    glooStats: {
      enabled: true,
    },
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
    create: false,
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
      stats: {
        enabled: true,
      },
    },
    enabled: true,
    proxyServiceAccount: {},
    readGatewaysFromAllNamespaces: true,
    upgrade: false,
    validation:  {
      enabled: lib.getElse(config, 'pkgs.gloo.validation.enabled', false),
      failurePolicy: "Ignore",
      secretName: "gateway-validation-certs",
      alwaysAcceptResources: true,
    },
  },
  gatewayProxies+: {
    pomeriumGatewayProxy: baseGatewayProxy(config, 'pomeriumGatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+: {
          'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
          'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
          'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': std.join(
            ',',
            gloo.dnsNames(expand.expandConfig(config), { type: 'pomerium' } )
            + pom.dnsNames(expand.expandConfig(config))
          ),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
        },
      },
    },
    internalGatewayProxy: baseGatewayProxy(config, 'internalGatewayProxy') {
      service+: {
        type: 'ClusterIP',
      },
    },
    gatewayProxy: baseGatewayProxy(config, 'gatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+: {
          'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
          'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
          'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': std.join(
            ',',
            gloo.dnsNames(expand.expandConfig(config), { type: 'external' } )
          ),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
        },
      },
    },
  },
};

function(config) values(config)
