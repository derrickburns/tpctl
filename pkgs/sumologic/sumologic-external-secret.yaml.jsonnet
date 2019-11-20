local externalSecret(config) = {
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'sumologic',
    namespace: 'sumologic',
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/sumologic/sumologic' % config.cluster.metadata.name,
        name: 'collector-url',
        property: 'collector-url',
      },
      {
        key: '%s/sumologic/sumologic' % config.cluster.metadata.name,
        name: 'accessID',
        property: 'accessID',
      },
      {
        key: '%s/sumologic/sumologic' % config.cluster.metadata.name,
        name: 'accessKey',
        property: 'accessKey',
      },
    ],
  },
};

function(config, prev) externalSecret(config)
