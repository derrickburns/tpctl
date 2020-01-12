local lib = import '../lib/lib.jsonnet';

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
  local extauth = 
    if lib.getElse(config, 'pkgs.pomerium.enabled', false) &&
       lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false)
    then {
      extauth: {
        extauthzServerRef: {
          name: 'pomerium-proxy',
          namespace: 'pomerium',
        },
      },
    } else { },
  spec: extauth {
    discovery: {
      fdsMode: 'WHITELIST',
    },
    discoveryNamespace: 'gloo-system',
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
