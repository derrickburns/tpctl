local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "false"
    },
    name: "datadog-agent",
    namespace: "datadog"
  },
  spec: {
    chart: {
      name": "datadog",
      repository: "https://kubernetes-charts.storage.googleapis.com/",
      version: "1.31.11"
    },
    releaseName: "datadog",
    values: {
      clusterAgent: {
        enabled: true,
        metricsProvider: {
          enabled: false
        }
      },
      datadog: {
        apiKeyExistingSecret: "datadog",
        appKeyExistingSecret: "datadog",
        "cluster.name": config.cluster.metadata.name,
        logLevel: config.logLevel,
        tokenKeyExistingSecret: "datadog"
      },
      kubeStateMetrics: {
        enabled: false
      }
    }
  }
};

function(config) helmrelease(config)
