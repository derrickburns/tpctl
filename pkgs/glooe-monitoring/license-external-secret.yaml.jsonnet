local license(config) = {
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    labels: {
      app: 'gloo',
      gloo: 'license',
    },
    name: 'license',
    namespace: 'gloo-system',
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/gloo-system/license' % config.cluster.metadata.name,
        name: 'license-key',
        property: 'license-key',
      },
    ],
  },
};

function(config, prev) license(config)
