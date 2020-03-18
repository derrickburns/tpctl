local configmap(config, namespace) = {
  apiVersion: 'v1',
  data: {
    'cwagentconfig.json': std.manifestJson(
      {
        agent: {
          region: config.cluster.metadata.region,
        },
        logs: {
          metrics_collected: {
            kubernetes: {
              cluster_name: config.cluster.metadata.name,
              metrics_collection_interval: 60,
            },
          },
          force_flush_interval: 15,
        },
      }
    ),
  },
  kind: 'ConfigMap',
  metadata: {
    name: 'cwagentconfig',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) configmap(config, namespace)
