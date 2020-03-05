local configmap(config, namespace) = {
  apiVersion: 'v1',
  kind: 'ConfigMap',
  metadata: {
    labels: {
      app: 'opencensus',
      component: 'oc-collector-conf',
    },
    name: 'oc-collector-conf',
    namespace: namespace,
  },
  data: {
    'oc-collector-config': std.manifestYamlDoc(
      {
        'queued-exporters': {
          'jaeger-all-in-one': {
            'jaeger-thrift-http': {
              'collector-endpoint': 'http://jaeger-collector.%s:14268/api/traces' % namespace,
              timeout: '5s',
            },
            'num-workers': 4,
            'queue-size': 100,
            'retry-on-failure': true,
            'sender-type': 'jaeger-thrift-http',
          },
        },
        receivers: {
          opencensus: {
            port: 55678,
          },
        },
      }
    ),
  },
};

function(config, prev, namespace) configmap(config, namespace)
