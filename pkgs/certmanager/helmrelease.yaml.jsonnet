local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, namespace) = (
  k8s.helmrelease('cert-manager-legacy', namespace, 'v0.14.0', 'https://charts.jetstack.io') {
    spec+: {
      values+: {
        prometheus: {
          enabled: lib.getElse(config, 'pkgs.prometheus.enabled', false),
          servicemonitors: {
            enabled: lib.getElse(config, 'pkgs.prometheusOperator.enabled', false),
          },
        },
      },
    },
  }
);

function(config, prev, namespace) helmrelease(config, namespace)
