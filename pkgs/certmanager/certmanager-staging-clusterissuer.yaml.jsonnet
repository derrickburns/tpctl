local ClusterIssuer(config) = {
  apiVersion: 'cert-manager.io/v1alpha2',
  kind: 'ClusterIssuer',
  metadata: {
    name: 'letsencrypt-staging',
  },
  "spec": {
    "acme": {
      "email": config.email,
      "privateKeySecretRef": {
        "name": "letsencrypt-staging"
      },
      server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
      "solvers": [
        {
          "dns01": {
            "route53": {
              "region": config.cluster.metadata.region,
            }
          },
          "selector": {
            "dnsZones": [
              "tidepool.org",
              "*.tidepool.org"
            ]
          }
        }
      ]
    }
  },
};

function(config) ClusterIssuer(config)
