local ClusterIssuer(config) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-production',
  },
  spec: {
    acme: {
      email: config.general.email,
      privateKeySecretRef: {
        name: 'letsencrypt-production',
      },
      server: 'https://acme-v02.api.letsencrypt.org/directory',
      solvers: [
        {
          dns01: {
            route53: { // XXX AWS dependency
              region: config.cluster.metadata.region,
            },
          },
          selector: {
            dnsZones: [
              config.cluster.metadata.domain,
              '*.%s' % config.cluster.metadata.domain,
            ],
          },
        },
      ],
    },
  },
};

function(config, prev, namespace) ClusterIssuer(config)
