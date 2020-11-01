local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local scrapeConfigs(me) = k8s.secret(me, name='prometheus-additionl-scrape-configs') + k8s.metadata(
  'kube-prometheus-stack-prometheus-additional-scrape-configs', me.namespace
) {
  stringData+: {
    'scrape-configs.yaml': std.manifestYamlDoc(
      [
        if lib.isEnabledAt(me, 'prometheus.staticConfigs.kafka') then {
          job_name: 'static/kafka',
          scrape_interval: '30s',
          metrics_path: '/metrics',
          scheme: 'http',
          static_configs:
            [
              {
                targets: me.prometheus.staticConfigs.kafka.nodeExporter.targets,
                labels: {
                  job: 'node-exporter',
                },
              },
              {
                targets: me.prometheus.staticConfigs.kafka.jmxExporter.targets,
                labels: {
                  job: 'jmx-exporter',
                },
              },
            ],
        },
      ],
    ),
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    scrapeConfigs(me),
  ]
)
