local ClusterIssuer(config) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-staging',
  },
  spec: {
    acme: {
      email: config.general.email,
      privateKeySecretRef: {
        name: 'letsencrypt-staging',
      },
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      solvers: [
        {
          dns01: {
            route53: { // XXX AWS dependency
              region: config.cluster.metadata.region,
            },
          },
          selector: {
            dnsZones: [
              'tidepool.org', // config.cluster.metadata.domain,
              '*.tidepool.org', // '*.%s' % config.cluster.metadata.domain,
              //config.cluster.metadata.domain,
              //'*.%s' % config.cluster.metadata.domain,
            ],
          },
        },
      ],
    },
  },
};

function(config, prev, namespace) ClusterIssuer(config)
