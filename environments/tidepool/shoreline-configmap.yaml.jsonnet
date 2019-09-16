local configmap(config, namespace) = {
  "apiVersion": "v1",
  "data": {
    "ClinicDemoUserId": ""
  },
  "kind": "ConfigMap",
  "metadata": {
    "name": "shoreline",
    "namespace":  namespace
  }
};

function(config, namespace) configmap(config,namespace)
