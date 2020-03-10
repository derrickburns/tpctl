local lib = import '../../lib/lib.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease( 'prometheus-operator', namespace, '8.7.0')
 { 
  local me = config.namespaces[namespace]["prometheus-operator"],
  spec+: {
    values+: {
      grafana: lib.getElse(me, 'grafana', {}),
      alertmanager: lib.getElse(me, 'alertmanager', {}),
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
