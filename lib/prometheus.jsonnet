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

  Podmonitor(config, name, namespace, port, selector, path='/metrics')::
    if lib.isEnabledAt(config, 'pkgs.prometheus')
    then $.podmonitor(name, selector, port, path='/metrics')
    else {}
}
