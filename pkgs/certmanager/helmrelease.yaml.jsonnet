local k8s = import '../../lib/k8s.jsonnet';

function(config, prev, namespace, pkg) 
  k8s.helmrelease('cert-manager', namespace, 'v0.14.0', 'https://charts.jetstack.io') 
