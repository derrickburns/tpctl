local Namespace(name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    annotations: {
      'linkerd.io/inject': 'disabled',
    },
    name: 'datadog',
  },
};

function(config, prev, namespace) Namespace(namespace)
