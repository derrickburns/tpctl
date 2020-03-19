local lib = import 'lib.jsonnet';

{
  podmonitor(name, namespace, port, selector, path):: {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'PodMonitor',
    metadata: {
      name: name,
      namespace: namespace,
    },
    spec: {
      podMetricsEndpoints: [
        {
          interval: '5s',
          path: path,
        } + if std.isString(port) then { port: port } else { targetPort: port },
      ],
      namespaceSelector: {
        matchNames: [
          namespace,
        ],
      },
      selector: {
        matchLabels: selector,
      },
    },
  },

  servicemonitor(me, targetPort):: {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'ServiceMonitor',
    metadata: {
      name: me.pkg,
      namespace: me.namespace,
    },
    spec: {
      endpoints: [
        {
          targetPort: targetPort,
        },
      ],
      selector: {
        matchLabels: {
          app: me.pkg,
        },
      },
      namespaceSelector: {
        matchNames: [me.namespace],
      },
    },
  },

  Podmonitor(config, name, namespace, port, selector, path='/metrics')::
    if lib.isEnabledAt(config, 'pkgs.prometheusOperator')
    then $.podmonitor(name, namespace, port, selector, path='/metrics')
    else {},
}
