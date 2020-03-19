local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, me) = k8s.helmrelease('datadog-agent', me.namespace, '2.0.4') {
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
        apiKeyExistingSecret: 'datadog',
        appKeyExistingSecret: 'datadog',
        clusterName: config.cluster.metadata.name,
        logLevel: config.general.logLevel,
      },
      kubeStateMetrics: {
        enabled: false,
      },
    },
  },
};

function(config, prev, namespace, pkg) helmrelease(config, lib.package(config, namespace, pkg))
