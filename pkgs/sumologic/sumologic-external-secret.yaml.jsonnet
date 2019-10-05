local externalSecret(config) = {
  "apiVersion": "kubernetes-client.io/v1",
  "kind": "ExternalSecret",
  "metadata": {
    "name": "sumologic",
    "namespace": "sumologic"
  },
  "secretDescriptor": {
    "backendType": "secretsManager",
    "data": [
      {
        "key": "%s/sumologic/sumologic" % config.metadata.name,
        "name": "collector-url",
        "property": "collector-url"
      }
    ]
  }
};

function(config) externalSecret(config)
