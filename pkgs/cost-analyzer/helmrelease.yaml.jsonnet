local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'cost-analyzer', version: '1.63.1', repository: 'https://kubecost.github.io/cost-analyzer/' }) {
  spec+: {
    values+: {
      local monitoring = global.package(me.config, 'prometheus-operator'),
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      global: {
        prometheus: {
          enabled: false,
          fqdn: 'http://%s-prometheus.%s:9090' % [monitoring.pkg, monitoring.namespace],
        },
        grafana: {
          enabled: false,
          domainName: '%s-grafana.%s' % [monitoring.pkg, monitoring.namespace],
        },
      },
      kubecostProductConfigs: {
        grafanaURL: 'https://grafana.%s' % me.config.cluster.metadata.domain,
      },
      serviceMonitor: {
        enabled: lib.isEnabled(monitoring),
      },
      prometheusRule: {
        enabled: true,
      },
      persistentVolume: {
        storageClass: 'gp2-expanding',
      },
    },
  },
};

function(config, prev, namespace, pkg) (
  local me = common.package(config, prev, namespace, pkg);
  [
    helmrelease(me),
  ]
)
