local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('goldilocks', namespace, '2.2.3', 'https://charts.fairwinds.com/stable') {
  spec+: {
    values: {
      installVPA: true,
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
