local lib = import 'lib.jsonnet';

local values(config) = {
      settings: {
        create: false,
      },
      namespace: {
        create: false,
      },
      discovery: {
        fdsMode: 'WHITELIST',
      },
      gatewayProxies: {
        gatewayProxyV2: {
          readConfig: true,
          gatewaySettings: {
	    disableGeneratedGateways: true
          },
          service: {
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
