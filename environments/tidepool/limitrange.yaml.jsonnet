local limitrange(config,namespace) = {
  "apiVersion": "v1",
  "kind": "LimitRange",
  "metadata": {
    "name": "limit-mem-cpu-per-container",
    "namespace" : namespace,
  },-
  "spec": {
    "limits": [
      {
        "default": {
          "cpu": "100m",
          "memory": "200Mi"
        },
        "defaultRequest": {
          "cpu": "50m",
          "memory": "100Mi"
        },
        "max": {
          "cpu": "800m",
          "memory": "1Gi"
        },
        "min": {
          "cpu": "50m",
          "memory": "99Mi"
        },
        "type": "Container"
      }
    ]
  }
};

function(config,prev,namespace) limitrange(config,namespace)


