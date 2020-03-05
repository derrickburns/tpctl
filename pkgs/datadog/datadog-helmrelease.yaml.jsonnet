local k8s = import '../../lib/k8s.jsonnet';

local helmrelease(config, namespace) = k8s.helmrelease('datadog-agent', namespace, '1.31.11') {
  spec+: {
    values: {
      clusterAgent: {
        enabled: true,
        metricsProvider: {
          enabled: false,
        },
      },
      datadog: {
        apiKeyExistingSecret: 'datadog',
        appKeyExistingSecret: 'datadog',
        'cluster.name': config.cluster.metadata.name,
        logLevel: config.general.logLevel,
        tokenKeyExistingSecret: 'datadog',
      },
      kubeStateMetrics: {
        enabled: false,
      },
    },
  },
};

function(config, prev, namespace) helmrelease(config, namespace)
