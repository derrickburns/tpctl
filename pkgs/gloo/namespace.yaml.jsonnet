local tracing = import '../tracing/lib.jsonnet';

local Namespace(config, name) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: name,
  },
};

function(config, prev, namespace) Namespace(config, namespace)
