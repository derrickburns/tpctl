local upstream(namespace) = {
  apiVersion: 'gloo.solo.io/v1',
  kind: 'Upstream',
  metadata: {
    name: 'pomerium-proxy',
    namespace: namespace,
  },
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
