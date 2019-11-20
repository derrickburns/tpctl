local namespace(config) = {
  apiVersion: "v1",
  kind: "Namespace",
  metadata: {
    annotations: {
      "linkerd.io/inject": "enabled"
    },
    labels: {
      name: "monitoring"
    },
    name: "monitoring"
  }
};

function(config, prev) namespace(config)
