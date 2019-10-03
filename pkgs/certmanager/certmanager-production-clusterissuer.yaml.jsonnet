local ClusterIssuer(config) = {
  apiVersion: "certmanager.k8s.io/v1alpha1",
  kind: "ClusterIssuer",
  metadata: {
    name: "letsencrypt-production",
  },
  spec: {
    acme: {
      server: "https://acme-v02.api.letsencrypt.org/directory",
      email: config.email,
      privateKeySecretRef: {
        name: "letsencrypt-production",
      },
      solvers: [
        {
          dns01: {
            route53: {
              region: config.cluster.metadata.region
            },
          },
        },
      ],
    },
  },
};

function(config) ClusterIssuer(config)
