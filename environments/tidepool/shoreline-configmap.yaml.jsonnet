local configmap(config, env) = {
  "apiVersion": "v1",
  "data": {
    "ClinicDemoUserId": ""
  },
  "kind": "ConfigMap",
  "metadata": {
    "name": "shoreline",
    "namespace":  env
  }
};

function(config, env) configmap(config,env)
