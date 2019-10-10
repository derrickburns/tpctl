local namespace(config) = {
  "apiVersion": "v1",
  "kind": "Namespace",
  "metadata": {
    "annotations": {
      "linkerd.io/inject": "enabled"
    },
    "labels": {
      "app": "gloo"
    },
    "name": "gloo-system"
  }
};

function(config) namespace(config)
