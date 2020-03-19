local expand = import '../../lib/expand.jsonnet';
local gloo = import '../../lib/gloo.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local tracing = import '../../lib/tracing.jsonnet';
local linkerd = import '../linkerd/lib.jsonnet';
local pom = import '../pomerium/lib.jsonnet';

local baseGatewayProxy(config, me, name) = {
  kind: {
    deployment: {
      replicas: lib.getElse(me, 'proxies.' + name + '.replicas', 2),
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
      'config.linkerd.io/skip-inbound-ports': 8081,
    },
    resources: {
      limits: {
        memory: '200Mi',
      },
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
  tracing: tracing.envoy(config),
};

local genvalues(config, me, version) = {
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
      tag: version,
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
    deployment: {
      resources: {
        limits: {
          memory: '200Mi',
        },
      },
    },
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
    validation: {
      enabled: lib.isEnabledAt(me, 'validation'),
      failurePolicy: 'Ignore',
      secretName: 'gateway-validation-certs',
      alwaysAcceptResources: true,
    },
  },
  gatewayProxies+: {
    pomeriumGatewayProxy: baseGatewayProxy(config, me, 'pomeriumGatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+: {
          'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
          'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
          'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': std.join(
            ',',
            gloo.dnsNames(expand.expandConfig(config), { type: 'pomerium' })
            + pom.dnsNames(expand.expandConfig(config))
          ),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
        },
      },
    },
    internalGatewayProxy: baseGatewayProxy(config, me, 'internalGatewayProxy') {
      service+: {
        type: 'ClusterIP',
      },
    },
    gatewayProxy: baseGatewayProxy(config, me, 'gatewayProxy') {
      service+: {
        type: 'LoadBalancer',
        extraAnnotations+: {
          'service.beta.kubernetes.io/aws-load-balancer-proxy-protocol': '*',
          'service.beta.kubernetes.io/aws-load-balancer-backend-protocol': 'tcp',
          'service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled': 'true',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': std.join(
            ',',
            gloo.dnsNames(expand.expandConfig(config), { type: 'external' })
          ),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,
        },
      },
    },
  },
};

local helmrelease(config, me) = (
  local version = lib.getElse(me, 'version', '1.3.14');
  k8s.helmrelease('gloo', me.namespace, version, 'https://storage.googleapis.com/solo-public-helm') {
    spec+: {
      values: genvalues(config, me, version),
    },
  }
);

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
