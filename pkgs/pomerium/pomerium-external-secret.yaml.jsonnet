local externalSecret(config) =
{
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'pomerium',
    namespace: 'pomerium',
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/pomerium/pomerium' % config.cluster.metadata.name,
        name: 'cookie-secret',
        property: 'cookie-secret',
      },
      {
        key: '%s/pomerium/pomerium' % config.cluster.metadata.name,
        name: 'shared-secret',
        property: 'shared-secret',
      },
      {
        key: '%s/pomerium/pomerium' % config.cluster.metadata.name,
        name: 'idp-client-id',
        property: 'idp-client-id',
      },
      {
	key: '%s/pomerium/pomerium' % config.cluster.metadata.name,
	name: 'idp-client-secret',
        property: 'idp-client-secret',
      },
      {
        key: '%s/pomerium/pomerium' % config.cluster.metadata.name,
        name: 'idp-service-account',
        property: 'idp-service-account',
      },
    ],
  },
};

function(config, prev) exteralSecret(config)
