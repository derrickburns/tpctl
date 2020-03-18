local configmap(config, namespace) = {
  apiVersion: 'v1',
  data: {
    'cluster.name': config.cluster.metadata.name,
    'logs.region': config.cluster.metadata.region,
  },
  kind: 'ConfigMap',
  metadata: {
    name: 'cluster-info',
    namespace: namespace,
  },
};

function(config, prev, namespace, pkg) configmap(config, namespace)
