local secret(namespace) = {
  apiVersion: 'v1',
  data: {
    GRAFANA_PASSWORD: 'dGlkZXBvb2w=',
    GRAFANA_USERNAME: 'YWRtaW4=',
  },
  kind: 'Secret',
  metadata: {
    labels: {
      app: 'gloo',
      gloo: 'glooe-observability-secrets',
    },
    name: 'glooe-observability-secrets',
    namespace: namespace,
  },
  type: 'Opaque',
};

function(config, prev, namespace, pkg) secret(namespace)
