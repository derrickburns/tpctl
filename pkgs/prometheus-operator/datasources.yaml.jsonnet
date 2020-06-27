local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local influxdb(me) = k8s.configmap(me, name='influxdb-datasource') + k8s.metadata(
  'influxdb-datasource', me.namespace
) {
  metadata+: {
    labels: {
      grafana_datasource: '1',
    },
  },
  data+: {
    'datasource.yaml': std.manifestYamlDoc({
      apiVersion: 1,
      datasources: [{
        name: 'InfluxDB',
        type: 'influxdb',
        access: 'proxy',
        database: 'k6',
        url: 'http://influxdb.monitoring:8086',
      }],
    },),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  if global.isEnabled(me.config, 'influxdb')
  then [
    influxdb(me),
  ]
  else {}
)
