local upstream(namespace) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Upstream',
  metadata: {
    name: 'pomerium-authorize',
    namespace: namespace,
  },
  spec: {
    discoveryMetadata: {},
    kube: {
      selector: {
        'app.kubernetes.io/instance': 'pomerium',
        'app.kubernetes.io/name': 'pomerium-authorize',
      },
      serviceName: 'pomerium-authorize',
      serviceNamespace: namespace,
      servicePort: 443,
    },
    sslConfig: {
      secretRef: {
        name: 'pomerium-authorize-tls',
        namespace: namespace,
      },
    },
  },
};

function(config, prev, namespace, pkg) upstream(namespace)
