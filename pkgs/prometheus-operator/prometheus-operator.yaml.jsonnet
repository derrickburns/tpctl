local Helmrelease(config) = {
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    name: 'prometheus-operator',
    namespace: 'monitoring',
  },
  spec: {
    chart: {
      repository: 'https://kubernetes-charts.storage.googleapis.com/',
      name: 'prometheus-operator',
      version: '5.1.0',
    },
    values+: {
      prometheus+: {
        prometheusSpec+: {
          externalLabels: {
            cluster: config.cluster.metadata.name,
            region: config.cluster.metadata.region,
          },
          serviceMonitorNamespaceSelector: {  // allows the operator to find target conf from multiple namespaces
            any: true,
          },
          thanos: {  // add Thanos Sidecar
            tag: 'v0.3.1',
            objectStorageConfig: {  // blob storage configuration to upload metrics
              key: 'thanos.yaml',
              name: config.pkgs.thanos.secret,
            },
          },
        },
      },
      grafana: {  // (optional) we don't need Grafana in all clusters
        enabled: true,
      },
      alertmanager: {
        enabled: false,
      },
    },
  },
};

function(config, prev) Helmrelease(config)
