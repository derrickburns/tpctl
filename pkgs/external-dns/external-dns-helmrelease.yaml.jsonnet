local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "false"
    },
    name: "external-dns",
    namespace: "external-dns"
  },
  spec: {
    chart: {
      name: "external-dns",
      repository: "https://kubernetes-charts.storage.googleapis.com/",
      version: "2.6.1"
    },
    releaseName: "external-dns",
    values: {
      aws: {
        region: config.cluster.metadata.region,
        zoneType: "public"
      },
      logLevel: config.logLevel,
      metrics: {
        enabled: true
      },
      provider: "aws",
      rbac: {
        create: true,
        serviceAccountName: "external-dns"
      },
      txtOwnerId: config.cluster.metadata.name,
      podSecurityContext: {
        fsGroup: 65534 // For ExternalDNS to be able to read Kubernetes and AWS token files
      },
    }
  }
};

function(config) helmrelease(config)
