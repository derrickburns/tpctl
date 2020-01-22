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
        key: 'qa1/gloo-system/license',
        name: 'license-key',
        property: 'license-key',
      },
    ],
  },
};

function(config, prev) license(config)
