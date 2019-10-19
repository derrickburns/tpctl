local lib = import 'lib.jsonnet';

local values(config) = {
  settings: {
    create: false,
  },
  namespace: {
    create: false,
  },
  discovery: {
    enabled: false,
    fdsMode: 'WHITELIST',
  },
  gateway: {
    certGenJob: {
      image: {
        repository: 'certgen',
      },
      restartPolicy: 'OnFailure',
    },
    conversionJob: {
      image: {
        repository: 'gateway-conversion',
      },
      restartPolicy: 'Never',
    },
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
      alwaysAcceptResources: true,
    },
  },
  gatewayProxies: {
    gatewayProxyV2: {
      readConfig: true,
      gatewaySettings: {
        disableGeneratedGateways: true,
      },
      tracing: {},
      podTemplate: {
        probes: false,
        image: {
          repository: 'gloo-envoy-wrapper',
        },
        httpPort: 8080,
        httpsPort: 8443,
        runAsUser: 10101,
      },
      service: {
        type: 'LoadBalancer',
        httpPort: 80,
        httpsPort: 443,
        extraAnnotations: {
          'service.beta.kubernetes.io/aws-load-balancer-type': 'nlb',
          'external-dns.alpha.kubernetes.io/alias': 'true',
          'external-dns.alpha.kubernetes.io/hostname': lib.dnsNames(config),
          'service.beta.kubernetes.io/aws-load-balancer-additional-resource-tags': 'cluster:%s' % config.cluster.metadata.name,

        },
      },
    },
  },
};

function(config) values(config)
