local externalSecret(config, namespace) = {
  "apiVersion": "kubernetes-client.io/v1",
  "kind": "ExternalSecret",
  "metadata": {
    "name": "marketo",
    "namespace": namespace,
  },
  "secretDescriptor": {
    "backendType": "secretsManager",
    "data": [
      {
        "key": "%s/%s/marketo" % [ config.cluster.metadata.name, namespace ],
        "name": "ID",
        "property": "ID"
      },
      {
        "key": "%s/%s/marketo" % [ config.cluster.metadata.name, namespace ],
        "name": "Secret",
        "property": "Secret"
      },
      {
        "key": "%s/%s/marketo" % [ config.cluster.metadata.name, namespace ],
        "name": "URL",
        "property": "URL"
      }
    ]
  }
};

function(config, prev, namespace) externalSecret(config, namespace)
