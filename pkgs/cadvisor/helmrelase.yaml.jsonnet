local k8s = import '../../lib/k8s.jsonnet';

local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('cadvisor', namespace, '1.1.0', 'https://code-chris.github.io/helm-charts') {
  spec+: {
    values: {
      metrics: {
       enabled: lib.getElse(config, 'pkgs.prometheusOperator', false),
      },.
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
