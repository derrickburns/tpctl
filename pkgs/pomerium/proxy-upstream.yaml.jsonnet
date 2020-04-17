local k8s = import '../../lib/k8s.jsonnet';
local common = import '../../lib/common.jsonnet';

local upstream(namespace) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata('pomerium-proxy', namespace) {
  spec: {
    discoveryMetadata: {},
    kube: {
      selector: {
        'app.kubernetes.io/instance': 'pomerium',
        'app.kubernetes.io/name': 'pomerium-proxy',
      },
      serviceName: 'pomerium-proxy',
      serviceNamespace: namespace,
      servicePort: 443,
    },
    sslConfig: {
      secretRef: {
        name: 'pomerium-proxy-tls',
        namespace: namespace,
      },
    },
  },
};

function(config, prev, namespace, pkg) upstream(namespace)
