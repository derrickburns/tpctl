local k8s = import '../../lib/k8s.jsonnet';

function(config, prev, namespace) k8s.clusterrolebinding('cadvisor', namespace)
