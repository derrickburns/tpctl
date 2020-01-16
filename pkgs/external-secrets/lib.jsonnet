local lib = import '../../lib/lib.jsonnet';

local externalSecret(config, name, namespace) = {
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: name,
    namespace: namespace,
  },
  spec: {
    backendType: 'secretsManager',
    dataFrom: [
      '%s/%s' % [config.cluster.metadata.name, namespace],
    ],
  },
};


