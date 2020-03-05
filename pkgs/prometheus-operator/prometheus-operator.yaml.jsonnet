local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, namespace) = { // XXX use helmrelease lib func
  apiVersion: 'helm.fluxcd.io/v1',
  kind: 'HelmRelease',
  metadata: {
    name: 'prometheus-operator',
    namespace: namespace,
  },
  spec: {
    chart: {
      repository: 'https://kubernetes-charts.storage.googleapis.com/',
      name: 'prometheus-operator',
      version: '8.7.0',
    },
    values+: {
      grafana: lib.getElse(config.namespaces[namespace], 'prometheus-operator.grafana', {}),
      alertmanager: lib.getElse(config.namespaces[namespace], 'prometheus-operator.alertmanager', {}),
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
