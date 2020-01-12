local lib = 'import ../lib/lib.jsonnet';

local settings(config) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Settings',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: 'default',
    namespace: 'gloo-system',
  },
  spec: {
    discovery: {
      fdsMode: 'WHITELIST',
    },
    discoveryNamespace: 'gloo-system',
    extauth: {
      extauthzServerRef: {
        name: 'extauth',
        namespace: 'pomerium',
      },
    },
    gloo: {
      invalidConfigPolicy: {
        invalidRouteResponseBody: 'Gloo Gateway has invalid configuration. Administrators should run `glooctl check` to find and fix config errors.',
        invalidRouteResponseCode: 404,
      },
      xdsBindAddr: '0.0.0.0:9977',
    },
    kubernetesArtifactSource: {},
    kubernetesConfigSource: {},
    kubernetesSecretSource: {},
    linkerd: lib.getElse(config, 'pkgs.linkerd.enabled', false),
    refreshRate: '60s',
  },
};

function(config) settings(config)
