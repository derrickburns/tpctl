local secret(config) = {
  "apiVersion": "kubernetes-client.io/v1",
  "kind": "ExternalSecret",
  "metadata": {
    "name": "datadog",
    "namespace": "datadog"
  },
  "secretDescriptor": {
    "backendType": "secretsManager",
    "data": [
      {
        "key": "%s/datadog/datadog" % config.cluster.metadata.name,
        "name": "api-key",
        "property": "api-key"
      },
      {
        "key": "%s/datadog/datadog" % config.cluster.metadata.name,
        "name": "app-key",
        "property": "app-key"
      },
      {
        "key": "%s/datadog/datadog" % config.cluster.metadata.name,
        "name": "token",
        "property": "token"
      }
    ]
  }
};

function(config) secret(config)
