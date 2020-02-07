local lib = import '../../lib/lib.jsonnet';

// Direct external authorization requests *back* to the proxy after adding the x-tidepool-extauth-request header.
// Then, a virtual service that selects requests based on that header will rewrite the request as needed and forward it to authorization server.
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
          name: 'auth',
          namespace: 'pomerium',
        },
        httpService: {
          response: {
            allowedUpstreamHeaders: [
              'x-pomerium-iap-jwt-assertion',
              'x-pomerium-authenticated-user-email',
              'x-pomerium-authenticated-user-id',
              'x-pomerium-authenticated-user-groups',
            ],
          },
          request: {
            allowedHeaders: [
              'x-pomerium-iap-jwt-assertion',
              'x-pomerium-authenticated-user-email',
              'x-pomerium-authenticated-user-id',
              'x-pomerium-authenticated-user-groups',
            ],
            headersToAdd: {
              'x-tidepool-extauth-request': 'true',
            },
          },
        },
      },
    } else {},
  spec: extauth {
    discovery: {
      fdsMode: 'WHITELIST',
    },
    discoveryNamespace: 'gloo-system',
    gateway: if lib.getElse(config, 'pkgs.gloo.validation.enabled', false) then {
      readGatewaysFromAllNamespaces: true,
      validation: {
        proxyValidationServerAddr: 'gloo:9988',
        alwaysAccept: true,
      },
    } else null,
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

function(config, prev) settings(config)
