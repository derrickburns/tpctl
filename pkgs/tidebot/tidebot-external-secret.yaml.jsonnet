local externalSecret(config) = {
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    labels: {
      app: 'tidebot',
    },
    name: 'tidebot',
    namespace: 'tidebot',
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/tidebot/tidebot' % config.cluster.metadata.name,
        name: 'HUBOT_GITHUB_TOKEN',
        property: 'HUBOT_GITHUB_TOKEN',
      },
      {
        key: '%s/tidebot/tidebot' % config.cluster.metadata.name,
        name: 'HUBOT_SLACK_TOKEN',
        property: 'HUBOT_SLACK_TOKEN',
      },
    ],
  },
};

function(config) externalSecret(config)
