local helmrelease(config) = {
  apiVersion: "helm.fluxcd.io/v1",
  kind: "HelmRelease",
  metadata: {
    annotations: {
      "fluxcd.io/automated": "false"
    },
    name: "certmanager",
    namespace: "certmanager"
  },
  spec: {
    chart: {
      name: "cert-manager",
      repository: "https://charts.jetstack.io",
      version: "v0.10.1"
    },
    releaseName: "certmanager",
    values: {
      global: {
         logLevel: 6
      },
      serviceAccount: {
        create: false,
        name : "certmanager"
      }
    }
  }
};

function(config) helmrelease(config)
