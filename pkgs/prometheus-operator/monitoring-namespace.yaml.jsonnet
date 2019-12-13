local namespace(config) = {
  apiVersion: "v1",
  kind: "Namespace",
  metadata: {
    labels: {
      name: "monitoring"
    },
    name: "monitoring"
  }
};

function(config, prev) namespace(config)
