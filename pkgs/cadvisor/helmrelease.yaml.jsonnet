local k8s = import '../../lib/k8s.jsonnet';

local lib = import '../../lib/lib.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('cadvisor', me.namespace, '1.1.0', 'https://code-chris.github.io/helm-charts') {
  spec+: {
    values: {
      metrics: {
       enabled: lib.isEnabledAt(config, 'pkgs.prometheusOperator'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
