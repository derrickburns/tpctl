local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local helmrelease(me) = k8s.helmrelease(me, { name: 'datadog-agent', version: '2.0.4' }) {
  _secretNames:: ['datadog'],
  spec+: {
    values: {
      clusterAgent: {
        enabled: true,
        metricsProvider: {
          enabled: false,
        },
        tokenExistingSecret: 'datadog',
      },
      datadog: {
        apiKeyExistingSecret: $._secretNames[0],
        appKeyExistingSecret: $._secretNames[0],
        clusterName: me.config.cluster.metadata.name,
        logLevel: me.config.general.logLevel,
      },
      kubeStateMetrics: {
        enabled: false,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(common.package(config, prev, namespace, pkg))
