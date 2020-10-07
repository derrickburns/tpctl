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
          interval: '30s',
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

  prometheusRule(me, name, groups, prometheus='kube-prometheus-stack-prometheus'):: k8s.k('monitoring.coreos.com/v1', 'PrometheusRule') + k8s.metadata(me.pkg, me.namespace) {
    metadata: {
      labels: {
        prometheus: prometheus,
        role: 'alert-rules',
      },
      name: '%s.rules' % name,
    },
    spec: {
      groups: groups,
    },
  },

  Podmonitor(me, port, selector, path='/metrics')::
    if global.isEnabled(me.config, 'kube-prometheus-stack')
    then $.podmonitor(me, port, selector, path='/metrics')
    else {},

  Servicemonitor(me, port)::
    if global.isEnabled(me.config, 'kube-prometheus-stack')
    then $.servicemonitor(me, port)
    else {},
}
