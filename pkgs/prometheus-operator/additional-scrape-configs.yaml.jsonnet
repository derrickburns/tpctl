local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local scrapeConfigs(me) = k8s.secret(me, name='prometheus-additionl-scrape-configs') + k8s.metadata(
  'prometheus-operator-prometheus-additional-scrape-configs', me.namespace
) {
  stringData+: {
    'scrape-configs.yaml': std.manifestYamlDoc(
      [
        {
          job_name: 'static/kafka',
          scrape_interval: '30s',
          metrics_path: '/metrics',
          scheme: 'http',
          static_configs:
            [
              {
                targets: [
                  'b-1.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11002',
                  'b-2.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11002',
                  'b-3.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11002',
                ],
                labels: {
                  job: 'node-exporter',
                },
              },
              {
                targets: [
                  'b-1.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11001',
                  'b-2.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11001',
                  'b-3.default-ops.dkr5k0.c4.kafka.us-west-2.amazonaws.com:11001',
                ],
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
