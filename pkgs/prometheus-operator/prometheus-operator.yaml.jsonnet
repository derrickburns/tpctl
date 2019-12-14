local lib = import "../../lib/lib.jsonnet";

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
      version: '8.2.0',
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
      grafana: lib.getElse(config, 'pkgs.prometheus-operator.grafana', {}),
      alertmanager: lib.getElse(config, 'pkgs.prometheus-operator.alertmanager', {}),
    },
  },
};

function(config, prev) Helmrelease(config)
