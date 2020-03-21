local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('cadvisor', me.namespace, '1.1.0', 'https://code-chris.github.io/helm-charts') {
  spec+: {
    values: {
      metrics: {
       enabled: global.isEnabled(config, 'prometheus-operator'),
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
