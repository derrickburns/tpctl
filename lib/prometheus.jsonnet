local global = import 'global.jsonnet';
local lib = import 'lib.jsonnet';

{
  podmonitor(me, port, selector, path):: {
    apiVersion: 'monitoring.coreos.com/v1',
    kind: 'PodMonitor',
    metadata: {
      name: me.pkg,
      namespace: me.namespace,
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
          me.namespace,
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

  Podmonitor(config, me, port, selector, path='/metrics')::
    if global.isEnabled(config, 'prometheus-operator')
    then $.podmonitor(me, port, selector, path='/metrics')
    else {},
}
