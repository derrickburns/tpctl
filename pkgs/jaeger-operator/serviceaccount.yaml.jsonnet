local k8s = import '../../lib/k8s.jsonnet';

function(config, prev, namespace, pkg) k8s.serviceaccount('jaeger-operator', namespace)
