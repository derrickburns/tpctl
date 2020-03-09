local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(namespace) = k8s.helmrelease('reloader', namespace, 'v0.0.51',
    'https://stakater.github.io/stakater-charts') { 
  spec: {
    values: {
      reloader: {
        serviceAccount: {
          create: false,
          name: 'reloader',
        },
      },
    },
  },
};

function(config, prev, namespace) helmrelease(namespace)
