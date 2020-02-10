local lib = import '../../lib/lib.jsonnet';

{
  externalSecret(config, name, namespace):: if lib.getElse(config, 'pkgs.external-secrets.enabled', false) then {
    apiVersion: 'kubernetes-client.io/v1',
    kind: 'ExternalSecret',
    metadata: {
      name: name,
      namespace: namespace,
    },
    spec: {
      backendType: 'secretsManager',
      dataFrom: [
        '%s/%s/%s' % [config.cluster.metadata.name, namespace, name],
      ],
    },
  } else {}, 
}
