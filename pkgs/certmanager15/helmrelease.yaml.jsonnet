local k8s = import '../../lib/k8s.jsonnet';

function(config, prev, namespace, pkg) 
  k8s.helmrelease('cert-manager', namespace, 'v0.14.1', 'https://charts.jetstack.io') {
    spec+: {
      values+: {
        serviceAccount: {
          create: false,
          name: 'cert-manager',
        },
        securityContext: {
          enabled: true,
        },
      },
    },
  }
