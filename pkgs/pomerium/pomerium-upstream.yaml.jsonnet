local lib = import '../../lib/lib.jsonnet';

local upstream(config) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Upstream',
  metadata: {
    name: 'auth',
    namespace: 'pomerium',
  },
  spec: {
    kube: {
      serviceName: 'internal-gateway-proxy',
      serviceNamespace: 'gloo-system',
      servicePort: 80,
    },
  },
};

function(config, prev)
  if lib.getElse(config, 'pkgs.pomerium.forwardauth.enabled', false)
  then upstream(config)
  else {}
