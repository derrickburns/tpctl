local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local configmap(config, me) = k8s.configmap(me) {
  data: {
    'oc-collector-config': std.manifestJsonEx(
      {
        'queued-exporters': {
          'jaeger-all-in-one': {
            'jaeger-thrift-http': {
              'collector-endpoint': 'http://jaeger-collector.%s:14268/api/traces' % me.namespace, // XXX hardcoding
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
      }, "  "),
  },
};

function(config, prev, namespace, pkg) configmap(config, common.package(config, prev, namespace, pkg))
