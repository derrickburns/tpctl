local lib = import '../../lib/lib.jsonnet';
local global = import '../../lib/global.jsonnet';

// Direct external authorization requests *back* to the proxy after adding the x-tidepool-extauth-request header.
// Then, a virtual service that selects requests based on that header will rewrite the request as needed and forward it to authorization server.

local settings(config, me) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Settings',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: 'default',
    namespace: me.namespace,
  },
  spec: {
    discovery: {
      fdsMode: 'WHITELIST',
    },
    discoveryNamespace: 'gloo-system',
    gateway: if lib.isEnabledAt(me, 'validation') then {
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
    linkerd: global.isEnabled(config, 'linkerd'),
    refreshRate: '60s',
  },
};

function(config, prev, namespace, pkg) settings(config, lib.package(config, namespace, pkg))
