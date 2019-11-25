local lib = import '../../lib/lib.jsonnet';

local externalSecret(config) = (
  local cluster = config.cluster.metadata.name;
  local namespace = lib.getElse(config, 'pkgs.linkerd-dashboard.namespace', 'flux');
  {
    apiVersion: 'kubernetes-client.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: 'linkerd-dashboard-config',
      namespace: namespace,
    },
    secretDescriptor: {
      backendType: 'secretsManager',
      data: [
        {
          key: '%s/%s/linkerd-dashboard-config' % [cluster, namespace],
          name: 'linkerd-dashboard.yaml',
          property: 'linkerd-dashboard.yaml',
        },
        {
          key: '%s/%s/linkerd-dashboard-config' % [cluster, namespace],
          name: 'github.key',
          property: 'github.key',
        },
      ],
    },
  }
);

function(config, prev) externalSecret(config)
