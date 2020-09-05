local common = import '../../lib/common.jsonnet';
local global = import '../../lib/global.jsonnet';
local k8s = import '../../lib/k8s.jsonnet';
local lib = import '../../lib/lib.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'cost-analyzer', version: lib.getElse(me, 'version', '1.63.1'), repository: 'https://kubecost.github.io/cost-analyzer/' }) {
  spec+: {
    values+: {
      affinity: {
        nodeAffinity: k8s.nodeAffinity(),
      },
      tolerations: [k8s.toleration()],
      global: {
        prometheus: {
          enabled: false,
          fqdn: 'http://prometheus-operator-prometheus.monitoring:9090',
        },
        grafana: {
          enabled: false,
          domainName: 'prometheus-operator-grafana.monitoring',
        },
      },
      kubecostProductConfigs: {
        grafanaURL: 'https://grafana.%s' % me.config.cluster.metadata.domain,
      },
      serviceMonitor: {
        enabled: global.isEnabled(me.config, 'prometheus-operator'),
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
