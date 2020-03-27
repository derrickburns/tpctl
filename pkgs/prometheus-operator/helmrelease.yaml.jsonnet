local lib = import '../../lib/lib.jsonnet';

local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('prometheus-operator', me.namespace, '8.12.3') {
  spec+: {
    values+: {
      grafana: lib.getElse(me, 'grafana', { enabled: false }),
      alertmanager: lib.getElse(me, 'alertmanager', { enabled: false }),
      prometheus: lib.getElse(me, 'prometheus', { enabled: true }),
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
