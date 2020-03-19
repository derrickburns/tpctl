local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) =
  k8s.helmrelease('cert-manager', namespace, 'v0.14.0', 'https://charts.jetstack.io') 

function(config, prev, namespace, pkg) helmrelease(config, namespace)
