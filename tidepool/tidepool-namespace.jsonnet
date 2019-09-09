local namespace(config, namespace) = {
  apiVersion: "v1",
  kind: "Namespace",
  metadata: {
    name: namespace,
    labels: {
      istio-injection: disabled
      global.linkerd.io/inject: enabled
      discovery.solo.io/function_discovery: enabled
    }
};

function(config, namespace) namespace(config, namespace)
