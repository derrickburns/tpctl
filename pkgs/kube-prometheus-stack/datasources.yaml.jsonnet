local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local datasources(me) = k8s.configmap(me, name='grafana-extra-datasources') + k8s.metadata(
  'prometheus-operator-grafana-datasources-default', me.namespace
) {
  metadata+: {
    labels: {
      grafana_datasource: '1',
    },
  },
  data+: {
    'datasource.yaml': std.manifestYamlDoc({
      apiVersion: 1,
      datasources: [
        if global.isEnabled(me.config, 'jaeger') then {
          name: 'Jaeger',
          type: 'jaeger',
          url: 'http://jaeger-query.observability:16686',
          access: 'server',
          'basic-auth': false,
        } else {},
        if global.isEnabled(me.config, 'influxdb') then {
          name: 'InfluxDB',
          type: 'influxdb',
          database: 'k6',
          url: 'http://influxdb.monitoring:8086',
        } else {},
      ],
    },),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    datasources(me),
  ]
)
