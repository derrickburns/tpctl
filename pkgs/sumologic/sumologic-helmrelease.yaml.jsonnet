local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "true"
    },
    name: "sumologic-fluentd",
    namespace: "sumologic"
  },
  spec: {
    chart: {
      name: "sumologic-fluentd",
      repository: "https://kubernetes-charts.storage.googleapis.com/",
      version: "1.1.0"
    },
    releaseName: "sumologic-fluentd",
    values: {
      rbac: {
        create: true
      },
      sumologic: {
        collectorUrlExistingSecret: "sumologic",
        readFromHead: false,
        sourceCategoryPrefix: "kubernetes/%s/" % config.cluster.metadata.name
      }
    }
  }
};

function(config) helmrelease(config)
