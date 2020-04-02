local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('goldilocks', me.namespace, '2.2.3', 'https://charts.fairwinds.com/stable') {
  spec+: {
    values: {
      installVPA: true,
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
