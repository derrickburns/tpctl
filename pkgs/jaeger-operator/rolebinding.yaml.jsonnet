local lib = import '../../lib/k8s.jsonnet';

function(config, prev, namespace) lib.clusterrolebinding('jaeger-operator', namespace)