local lib = import '../../lib/lib.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease( 'prometheus-operator', namespace, '8.7.0')
 { 
  spec: {
    values+: {
      grafana: lib.getElse(config.namespaces[namespace], 'prometheus-operator.grafana', {}),
      alertmanager: lib.getElse(config.namespaces[namespace], 'prometheus-operator.alertmanager', {}),
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
