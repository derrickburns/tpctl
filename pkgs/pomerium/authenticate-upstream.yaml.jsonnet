local k8s = import '../../lib/k8s.jsonnet';

local upstream(namespace) = k8s.k('gloo.solo.io/v1', 'Upstream') + k8s.metadata('pomerium-authenticate', namespace) {
  spec: {
    discoveryMetadata: {},
    kube: {
      selector: {
        'app.kubernetes.io/instance': 'pomerium',
        'app.kubernetes.io/name': 'pomerium-authenticate',
      },
      serviceName: 'pomerium-authenticate',
      serviceNamespace: namespace,
      servicePort: 443,
    },
    sslConfig: {
      secretRef: {
        name: 'pomerium-authenticate-tls',
        namespace: namespace,
      },
    },
  },
};

function(config, prev, namespace, pkg) upstream(namespace)
