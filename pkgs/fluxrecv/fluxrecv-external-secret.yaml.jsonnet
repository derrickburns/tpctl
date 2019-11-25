local lib = '../../lib/lib.jsonnet';

local externalSecret(config) = {
  local namespace = lib.getElse(config, 'pkgs.fluxrecv.namespace', flux),
  local cluster = config.cluster.metadata.name,
  apiVersion: 'kubernetes-client.io/v1',
  kind: 'ExternalSecret',
  metadata: {
    name: 'fluxrecv-config',
    namespace: namespace,
  },
  secretDescriptor: {
    backendType: 'secretsManager',
    data: [
      {
        key: '%s/%s/fluxrecv-config' % [cluster, namespace],
        name: 'fluxrecv.yaml',
        property: 'fluxrecv.yaml',
      },
      {
        key: '%s/%s/fluxrecv-config' % [cluster, namespace],
        name: 'github.key',
        property: 'github.key',
      },
    ],
  },
};

function(config) externalSecret(config)
