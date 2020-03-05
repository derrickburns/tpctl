local upstream(namespace) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Upstream',
  metadata: {
    name: 'pomerium-authenticate',
    namespace: namespace,
  },
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

function(config, prev, namespace) upstream(namespace)
