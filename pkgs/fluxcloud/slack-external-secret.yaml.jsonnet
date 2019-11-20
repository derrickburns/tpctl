local externalSecret(config) = {
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'slack',
    namespace: 'flux',
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/flux/slack' % config.cluster.metadata.name,
        name: 'url',
        property: 'url',
      },
    ],
  },
};

function(config, prev) externalSecret(config)
