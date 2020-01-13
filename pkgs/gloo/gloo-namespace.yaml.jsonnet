local tracing = import '../tracing/lib.jsonnet';

local namespace(config) = {
  apiVersion: 'v1',
  kind: 'Namespace',
  metadata: {
    labels: {
      app: 'gloo',
    },
    name: 'gloo-system',
    annotations:  tracing.tracingAnnotation(config)
  },
};

function(config, prev) namespace(config)
