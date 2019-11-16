local lib = import '../lib/lib.jsonnet';

local settings(config) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Settings',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: 'default',
    namespace: lib.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
  },
  spec: {
    gateway: {
      validation: {
        alwaysAccept: false,
      },
    },
    discovery: {
      fdsMode: 'WHITELIST',
    },
    discoveryNamespace: lib.getElse(config, 'pkgs.gloo.namespace', 'gloo-system'),
    kubernetesArtifactSource: {},
    kubernetesConfigSource: {},
    kubernetesSecretSource: {},
    linkerd: true,
    refreshRate: '60s',
  },
};

function(config) settings(config)
