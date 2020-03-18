local lib = import '../../lib/k8s.jsonnet';

function(config, prev, namespace, pkg) lib.clusterrolebinding('jaeger-operator', namespace)
