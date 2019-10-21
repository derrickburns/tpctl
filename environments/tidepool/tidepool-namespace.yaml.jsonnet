local gen_namespace(config, namespace) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    name: namespace,
    labels: {
      'discovery.solo.io/function_discovery': 'disabled',
    },
    annotations: {
      'istio-injection': 'disabled',
      'linkerd.io/inject': 'enabled',
    },
  },
};

function(config, prev, namespace) gen_namespace(config, namespace)
