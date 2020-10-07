local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local datasources(me) = k8s.configmap(me, name='grafana-extra-datasources') + k8s.metadata(
  'grafana-extra-datasources', me.namespace
) {
  metadata+: {
    labels: {
      grafana_datasource: '1',
    },
  },
  data+: {
    'datasources-default.yaml': std.manifestYamlDoc({
      apiVersion: 1,
      datasources: [] + if global.isEnabled(me.config, 'influxdb') then [{
        local influxdb = global.package(me.config, 'influxdb'),
        name: 'InfluxDB',
        type: 'influxdb',
        database: 'k6',
        url: 'http://influxdb.%s:8086' % influxdb.namespace,
      }] else [] + if global.isEnabled(me.config, 'jaeger') then [{
        local jaeger = global.package(me.config, 'jaeger'),
        name: 'Jaeger',
        type: 'jaeger',
        url: 'http://jaeger-query.%s:16686' % jaeger.namespace,
        access: 'server',
        'basic-auth': false,
      }] else [],
    },),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    datasources(me),
  ]
)
