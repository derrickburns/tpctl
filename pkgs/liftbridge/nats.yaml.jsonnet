local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';

local natscluster(me) = k8s.k('nats.io/v1alpha2', 'NatsCluster') + k8s.metadata(me.pkg + "-nats", me.namespace) {
  spec+: {
    natsConfig: {
      writeDeadline: '5s',
    },
    pod: {
      annotations: {
        'sidecar.istio.io/inject': 'false',
      },
      enableConfigReload: true,
      enableMetrics: true,
      metricsImage: 'synadia/prometheus-nats-exporter',
      metricsImageTag: '0.5.0',
      reloaderImage: 'connecteverything/nats-server-config-reloader',
      reloaderImagePullPolicy: 'IfNotPresent',
      reloaderImageTag: '0.6.0',
    },
    size: 3,
    version: '2.1.0',
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    natscluster(me),
  ]
)
