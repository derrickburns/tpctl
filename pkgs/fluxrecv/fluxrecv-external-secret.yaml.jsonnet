local lib = import '../../lib/lib.jsonnet';

local externalSecret(config) = (
  local cluster = config.cluster.metadata.name;
  local namespace = lib.getElse(config, 'pkgs.fluxrecv.namespace', 'flux');
  {
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
  }
);

function(config, prev) externalSecret(config)
