local ClusterIssuer(config) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-staging',
  },
  spec: {
    acme: {
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      email: config.email,
      privateKeySecretRef: {
        name: 'letsencrypt-staging',
      },
      dns01: {
        providers: [
          {
            name: 'route53',
            route53: {
              region: config.cluster.metadata.region,
            },
          },
        ],
      },
    },
  },
};

function(config) ClusterIssuer(config)
