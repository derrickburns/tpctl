local global = import 'global.jsonnet';
local k8s = import 'k8s.jsonnet';
local lib = import 'lib.jsonnet';

{
  metadata(config, port, path='/metrics'):: {
    metadata+: {
      annotations+:
        (if global.isEnabled(config, 'prometheus')
         then {
           'prometheus.io/path': path,
           'prometheus.io/port': port,
           'prometheus.io/scrape': 'true',
         }
         else {}),
    },
  },

  podmonitor(me, port, selector, path):: k8s.k('monitoring.coreos.com/v1', 'PodMonitor') + k8s.metadata(me.pkg, me.namespace) {
    spec: {
      podMetricsEndpoints: [
        {
          interval: '5s',
          path: path,
        } + if std.isString(port) then { port: port } else { targetPort: port },
      ],
      namespaceSelector: {
        matchNames: [
          me.namespace,
        ],
      },
      selector: {
        matchLabels: selector,
      },
    },
  },

  servicemonitor(me, port):: k8s.k('monitoring.coreos.com/v1', 'ServiceMonitor') + k8s.metadata(me.pkg, me.namespace) {
    spec: {
      endpoints: [
        if std.isString(port) then { port: port } else { targetPort: port },
      ],
      selector: {
        matchLabels: {
          app: me.pkg,
        },
      },
      namespaceSelector: {
        matchNames: [
          me.namespace,
        ],
      },
    },
  },

  Podmonitor(me, port, selector, path='/metrics')::
    if global.isEnabled(me.config, 'prometheus-operator')
    then $.podmonitor(me, port, selector, path='/metrics')
    else {},

  Servicemonitor(me, port)::
    if global.isEnabled(me.config, 'prometheus-operator')
    then $.servicemonitor(me, port)
    else {},
}
