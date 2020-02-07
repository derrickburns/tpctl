local lib = import '../../lib/lib.jsonnet';

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
      version: '8.7.0',
    },
    values+: {
      grafana: lib.getElse(config, 'pkgs.prometheus-operator.grafana', {}),
      alertmanager: lib.getElse(config, 'pkgs.prometheus-operator.alertmanager', {}),
    },
  },
};

function(config, prev) Helmrelease(config)
