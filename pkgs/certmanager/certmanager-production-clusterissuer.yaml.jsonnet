local ClusterIssuer(config) = {
  apiVersion: 'certmanager.k8s.io/v1alpha1',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-production',
  },
  spec: {
    acme: {
      server: 'https://acme-v02.api.letsencrypt.org/directory',
      email: config.email,
      privateKeySecretRef: {
        name: 'letsencrypt-production',
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
