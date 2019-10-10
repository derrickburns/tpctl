local deployment(context) = {
  apiVersion: "apps/v1",
  kind: "Deployment",
  metadata: {
    name: "external-secrets",
    namespace: "external-secrets"
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: {
        "app.kubernetes.io/instance": "external-secrets",
        "app.kubernetes.io/name": "kubernetes-external-secrets"
      }
    },
    template: {
      metadata: {
        labels: {
          "app.kubernetes.io/instance": "external-secrets",
          "app.kubernetes.io/name": "kubernetes-external-secrets"
        }
      },
      spec: {
        containers: [
          {
            env: [
              {
                name: "AWS_REGION",
                value: config.cluster.metadata.region,
              },
              {
                name: "LOG_LEVEL",
                value: config.logLevel,
              },
              {
                name: "METRICS_PORT",
                value: "3001"
              },
              {
                name: "POLLER_INTERVAL_MILLISECONDS",
                value: config.pkgs.external-secrets.poller_interval,
              }
            ],
            image: "godaddy/kubernetes-external-secrets:1.5.0",
            imagePullPolicy: "IfNotPresent",
            name: "kubernetes-external-secrets",
            securityContext: {
              fsGroup: 65534
            }
          }
        ],
        "serviceAccountName": "external-secrets"
      }
    }
  }
};

function(config) deployment(config)


