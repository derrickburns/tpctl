local externalSecret(config, namespace) = {
  "apiVersion": "kubernetes-client.io/v1",
  "kind": "ExternalSecret",
  "metadata": {
    "name": "mongo",
    "namespace": namespace,
  },
  "secretDescriptor": {
    "backendType": "secretsManager",
    "data": [
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Addresses",
        "property": "Addresses"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Database",
        "property": "Database"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "OptParams",
        "property": "OptParams"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Password",
        "property": "Password"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Tls",
        "property": "Tls"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Username",
        "property": "Username"
      },
      {
        "key": "%s/%s/mongo" % [ config.cluster.metadata.name, namespace ],
        "name": "Scheme",
        "property": "Scheme"
      }
    ]
  }
};

function(config, prev, namespace) externalSecret(config, namespace)
